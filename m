Return-Path: <netdev+bounces-3684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BED5870853E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:44:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B78AD1C210D3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A312109A;
	Thu, 18 May 2023 15:44:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976FD53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:44:34 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3482993;
	Thu, 18 May 2023 08:44:32 -0700 (PDT)
Received: from fpc (unknown [46.242.14.200])
	by mail.ispras.ru (Postfix) with ESMTPSA id E431444C1015;
	Thu, 18 May 2023 15:44:28 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru E431444C1015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1684424669;
	bh=4UYZ2IcmL1KklQiEztNjChNplhlI6pOuen+vw5gYh7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kx2tqMuCqGe7yKU3/GeQZ06VhdriXeA/5nKMyfZ2/eRm8uC60sAgVtUeAfHXwW0bl
	 uLmfY2sEIfZHLxCKrYXbet5anJxGPxhak2PVLtNFYkCynQ2+zmmprL3OScahQwfarS
	 MwHq+3s0EmwsYfyqSfBy7O8XR0VN4ScmK87UtPuc=
Date: Thu, 18 May 2023 18:44:24 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Hillf Danton <hdanton@sina.com>
Cc: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Vallo <kvalo@kernel.org>,
	syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH v3 1/2] wifi: ath9k: fix races between ath9k_wmi_cmd and
 ath9k_wmi_ctrl_rx
Message-ID: <20230518154424.62urbguy4rxetkty@fpc>
References: <20230425192607.18015-1-pchelkin@ispras.ru>
 <20230425230708.2132-1-hdanton@sina.com>
 <20230426190206.ni2au5mpjc5oty67@fpc>
 <20230518102437.4443-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518102437.4443-1-hdanton@sina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 06:24:37PM +0800, Hillf Danton wrote:
> Fedor Pchelkin <pchelkin@ispras.ru> writes:
> 
> > On Wed, Apr 26, 2023 at 07:07:08AM +0800, Hillf Danton wrote: 
> >> Given similar wait timeout[1], just taking lock on the waiter side is not
> >> enough wrt fixing the race, because in case job done on the waker side,
> >> waiter needs to wait again after timeout.
> >> 
> >
> > As I understand you correctly, you mean the case when a timeout occurs
> > during ath9k_wmi_ctrl_rx() callback execution. I suppose if a timeout has
> > occurred on a waiter's side, it should return immediately and doesn't have
> > to care in which state the callback has been at that moment.
> >
> > AFAICS, this is controlled properly with taking a wmi_lock on waiter and
> > waker sides, and there is no data corruption.
> >
> > If a callback has not managed to do its work entirely (performing a
> > completion and subsequently waking waiting thread is included here), then,
> > well, it is considered a timeout, in my opinion.
> >
> > Your suggestion makes a wmi_cmd call to give a little more chance for the
> > belated callback to complete (although timeout has actually expired). That
> > is probably good, but increasing a timeout value makes that job, too. I
> > don't think it makes any sense on real hardware.
> >
> > Or do you mean there is data corruption that is properly fixed with your patch?
> 
> Given complete() not paired with wait_for_completion(), what is the
> difference after this patch?

The main thing in the patch is making ath9k_wmi_ctrl_rx() release wmi_lock
after calling ath9k_wmi_rsp_callback() which does copying data into the
shared wmi->cmd_rsp_buf buffer. Otherwise there can occur a data
corrupting scenario outlined in the patch description (added it here,
too).

On Tue, 25 Apr 2023 22:26:06 +0300, Fedor Pchelkin wrote:
> CPU0					CPU1
> 
> ath9k_wmi_cmd(...)
>   mutex_lock(&wmi->op_mutex)
>   ath9k_wmi_cmd_issue(...)
>   wait_for_completion_timeout(...)
>   ---
>   timeout
>   ---
> 					/* the callback is being processed
> 					 * before last_seq_id became zero
> 					 */
> 					ath9k_wmi_ctrl_rx(...)
> 					  spin_lock_irqsave(...)
> 					  /* wmi->last_seq_id check here
> 					   * doesn't detect timeout yet
> 					   */
> 					  spin_unlock_irqrestore(...)
>   /* last_seq_id is zeroed to
>    * indicate there was a timeout
>    */
>   wmi->last_seq_id = 0
>   mutex_unlock(&wmi->op_mutex)
>   return -ETIMEDOUT
> 
> ath9k_wmi_cmd(...)
>   mutex_lock(&wmi->op_mutex)
>   /* the buffer is replaced with
>    * another one
>    */
>   wmi->cmd_rsp_buf = rsp_buf
>   wmi->cmd_rsp_len = rsp_len
>   ath9k_wmi_cmd_issue(...)
>     spin_lock_irqsave(...)
>     spin_unlock_irqrestore(...)
>   wait_for_completion_timeout(...)
> 					/* the continuation of the
> 					 * callback left after the first
> 					 * ath9k_wmi_cmd call
> 					 */
> 					  ath9k_wmi_rsp_callback(...)
> 					    /* copying data designated
> 					     * to already timeouted
> 					     * WMI command into an
> 					     * inappropriate wmi_cmd_buf
> 					     */
> 					    memcpy(...)
> 					    complete(&wmi->cmd_wait)
>   /* awakened by the bogus callback
>    * => invalid return result
>    */
>   mutex_unlock(&wmi->op_mutex)
>   return 0

So before the patch the wmi->last_seq_id check in ath9k_wmi_ctrl_rx()
wasn't helpful in case wmi->last_seq_id value was changed during
ath9k_wmi_rsp_callback() execution because of the next ath9k_wmi_cmd()
call.

With the proposed patch the wmi->last_seq_id check in ath9k_wmi_ctrl_rx()
accomplishes its job as:
 - the next ath9k_wmi_cmd call changes last_seq_id value under lock so
   it either waits for a belated ath9k_wmi_ctrl_rx() to finish or updates
   last_seq_id value so that the timeout check in ath9k_wmi_ctrl_rx()
   indicates that the waiter side has timeouted and we shouldn't further
   process the callback.
 - memcopying in ath9k_wmi_rsp_callback() is made to a valid place if
   the last_seq_id check was successful under the lock.

