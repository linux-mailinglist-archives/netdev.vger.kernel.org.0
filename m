Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F6F6B80D7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjCMShb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjCMShQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:37:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC7E86DF6;
        Mon, 13 Mar 2023 11:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3035361468;
        Mon, 13 Mar 2023 18:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A01C4339B;
        Mon, 13 Mar 2023 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678732511;
        bh=83rGdz49K5sFglwLL3OYaBkD8n6tZwCy7h+0mUdPCW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X84fjntKJVXpUrxP7JSq6Nruco0it2mhsgBZwOO0t8DlsRbar0aKwnZRK86Wsy1aM
         0nQTa1zTms2lsA4fC8/uULZ2jm6fpo6fcPwB+5KHnL4qr/InI9HRIAXi+JcWAXRW31
         mX0OFiFLB4BesSc2I+e6eo3GwLCQq+z345oroNgTN8zT5SJh2+BV5+3UtSUsy2PDiH
         ZChBP2TG89TfCDlEPMu/IDX7PVSDX7pbKGQJBV4zbt61A9I2v1oGJL1RrxTZke7nah
         XJB5mN5HwuGQu6qQ5bWi92Uk5Xy46w3Oj3y5K4zvSNqkgqeuVYKtZR8F2o/WsIZ1tj
         CKvWIQ0K32CsQ==
Date:   Mon, 13 Mar 2023 11:35:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH net-next v2 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230313113510.02c107b3@kernel.org>
In-Reply-To: <ZA9EMJgoNsxfOhwV@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
        <20230214210811.448b5ec4@kernel.org>
        <Y+0Wjrc9shLkH+Gg@hog>
        <20230215111020.0c843384@kernel.org>
        <Y+1pX/vL8t2nU00c@hog>
        <20230215195748.23a6da87@kernel.org>
        <Y+5Yd/8tjCQNOF31@hog>
        <20230221191944.4d162ec7@kernel.org>
        <Y/eT/M+b6jUtTdng@hog>
        <20230223092945.435b10ea@kernel.org>
        <ZA9EMJgoNsxfOhwV@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 16:41:36 +0100 Sabrina Dubroca wrote:
> > > Yes, I was looking into that earlier this week. I think we could reuse
> > > a similar mechanism for rekeying. tls_dev_add takes tcp_sk->write_seq,
> > > we could have a tls_dev_rekey op passing the new key and new write_seq
> > > to the driver. I think we can also reuse the ->eor trick from
> > > tls_set_device_offload, and we wouldn't have to look at
> > > skb->decrypted. Close and push the current SW record, mark ->eor, pass
> > > write_seq to the driver along with the key. Also pretty close to what
> > > tls_device_resync_tx does.  
> > 
> > That sounds like you'd expose the rekeying logic to the drivers?
> > New op, having to track seq#...  
> 
> Well, we have to call into the drivers to install the key, whether
> that's a new rekey op, or adding an update argument to ->tls_dev_add,
> or letting the driver guess that it's a rekey (or ignore that and just
> install the key if rekey vs initial key isn't a meaningful
> distinction).
> 
> We already feed drivers the seq# with ->tls_dev_add, so passing it for
> rekeys as well is not a big change.
> 
> Does that seem problematic? Adding a rekey op seemed more natural to
> me than simply using the existing _del + _add ops, but maybe we can
> get away with just using those two ops.

Theoretically a rekey op is nicer and cleaner. Practically the quality
of the driver implementations will vary wildly*, and it's a significant
time investment to review all of them. So for non-technical reasons my
intuition is that we'd deliver a better overall user experience if we
handled the rekey entirely in the core.

Wait for old key to no longer be needed, _del + _add, start using the
offload again.

* One vendor submitted a driver claiming support for TLS 1.3, when 
  TLS 1.3 offload was rejected by the core. So this is the level of
  testing and diligence we're working with :(
