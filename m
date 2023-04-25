Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAC26EDD41
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjDYHyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDYHyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:54:40 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC44A93;
        Tue, 25 Apr 2023 00:54:38 -0700 (PDT)
Received: from fpc (unknown [10.10.165.13])
        by mail.ispras.ru (Postfix) with ESMTPSA id B178F4076B3E;
        Tue, 25 Apr 2023 07:54:33 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru B178F4076B3E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1682409273;
        bh=x/dcm2H+pi6gUOqFCVOxGTCuLDZsjOAvdeX9hDCiq50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ha5x9mUs3UEtB19J1XCR4MRHoL6FR6LT2yNTo2JYsvcMVjPHA/bq8OmLTktyraXoP
         4/NlJ+NtnRg2/Kn+PNV3/5ADOUAnJwDLm9OT+nhQsXJColKxExzaplOSPtM7HygpfJ
         +ysErXCQ/eOuCMgonfLq9PWYyVCbcoQv3zfUOLYU=
Date:   Tue, 25 Apr 2023 10:54:26 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org,
        syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com,
        syzbot+df61b36319e045c00a08@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] wifi: ath9k: fix races between ath9k_wmi_cmd and
 ath9k_wmi_ctrl_rx
Message-ID: <20230425075426.ubfnohsqe3c2cjdq@fpc>
References: <20230424191826.117354-1-pchelkin@ispras.ru>
 <20230425033832.2041-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425033832.2041-1-hdanton@sina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:38:32AM +0800, Hillf Danton wrote:
> On 24 Apr 2023 22:18:26 +0300 Fedor Pchelkin <pchelkin@ispras.ru>
> > Currently, the synchronization between ath9k_wmi_cmd() and
> > ath9k_wmi_ctrl_rx() is exposed to a race condition which, although being
> > rather unlikely, can lead to invalid behaviour of ath9k_wmi_cmd().
> > 
> > Consider the following scenario:
> > 
> > CPU0					CPU1
> > 
> > ath9k_wmi_cmd(...)
> >   mutex_lock(&wmi->op_mutex)
> >   ath9k_wmi_cmd_issue(...)
> >   wait_for_completion_timeout(...)
> >   ---
> >   timeout
> >   ---
> > 					/* the callback is being processed
> > 					 * before last_seq_id became zero
> > 					 */
> > 					ath9k_wmi_ctrl_rx(...)
> > 					  spin_lock_irqsave(...)
> > 					  /* wmi->last_seq_id check here
> > 					   * doesn't detect timeout yet
> > 					   */
> > 					  spin_unlock_irqrestore(...)
> >   /* last_seq_id is zeroed to
> >    * indicate there was a timeout
> >    */
> >   wmi->last_seq_id = 0
> 
> Without	wmi->wmi_lock held, updating last_seq_id on the waiter side
> means it is random on the waker side, so the fix below is incorrect.
> 

Thank you for noticing! Of course that should be done.

> >   mutex_unlock(&wmi->op_mutex)
> >   return -ETIMEDOUT
> > 
> > ath9k_wmi_cmd(...)
> >   mutex_lock(&wmi->op_mutex)
> >   /* the buffer is replaced with
> >    * another one
> >    */
> >   wmi->cmd_rsp_buf = rsp_buf
> >   wmi->cmd_rsp_len = rsp_len
> >   ath9k_wmi_cmd_issue(...)
> >     spin_lock_irqsave(...)
> >     spin_unlock_irqrestore(...)
> >   wait_for_completion_timeout(...)
> > 					/* the continuation of the
> > 					 * callback left after the first
> > 					 * ath9k_wmi_cmd call
> > 					 */
> > 					  ath9k_wmi_rsp_callback(...)
> > 					    /* copying data designated
> > 					     * to already timeouted
> > 					     * WMI command into an
> > 					     * inappropriate wmi_cmd_buf
> > 					     */
> > 					    memcpy(...)
> > 					    complete(&wmi->cmd_wait)
> >   /* awakened by the bogus callback
> >    * => invalid return result
> >    */
> >   mutex_unlock(&wmi->op_mutex)
> >   return 0
> > 
> > To fix this, move ath9k_wmi_rsp_callback() under wmi_lock inside
> > ath9k_wmi_ctrl_rx() so that the wmi->cmd_wait can be completed only for
> > initially designated wmi_cmd call, otherwise the path would be rejected
> > with last_seq_id check.
> > 
> > Also move recording the rsp buffer and length into ath9k_wmi_cmd_issue()
> > under the same wmi_lock with last_seq_id update to avoid their racy
> > changes.
> 
> Better in a seperate one.

Well, they are parts of the same problem but now it seems more relevant
to divide the patch in two: the first one for incorrect last_seq_id
synchronization and the second one for recording rsp buffer under the
lock. Thanks!
