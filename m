Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DFB37ED16
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385182AbhELUHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382919AbhELTsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 15:48:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30A84613EB;
        Wed, 12 May 2021 19:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620848854;
        bh=PJ3ESWcwcY+cOUBfUMzEZA7WXUM3t+690sUs4xNmQ1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vqp+X6/R66gWgNkKRIpjNdjvJlhKCX2XmADLPwMj/MynViRqsijk2h5bBswVj4HkY
         DFPkMElC1Lx1MiV7nE40MB4gezu2FY4I9okjMA+O41QafjnYBvesu47gCHyDD1DxSf
         zL9eyhWiKn6dkFzud6tdmxguLLfPozyRPlKFTTOR4ihpoiTxY5iSXQn77zlnU1Iq+p
         z9pIMmDoK2uRp0yhSIpPwu/VaO9nQ3RUewOGXdr4Y4JXjmvURSoE5QtWKA3qN84qtj
         wk2aY115si1I3DJHsn2TUkukSASzeVvD96uhUyCGiBJrj6nP/gjMzb9bkAfYHQtQ5R
         rAD3kAg5Qnohg==
Date:   Wed, 12 May 2021 12:47:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: Re: [Linuxarm] Re: [PATCH net v6 3/3] net: sched: fix tx action
 reschedule issue with stopped queue
Message-ID: <20210512124731.2993dac7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <62054a31-4708-1696-60d5-b33e4993cddc@huawei.com>
References: <1620610956-56306-1-git-send-email-linyunsheng@huawei.com>
        <1620610956-56306-4-git-send-email-linyunsheng@huawei.com>
        <20210510212232.3386c5b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c676404c-f210-b0cb-ced3-5449676055a8@huawei.com>
        <8db8e594-9606-2c93-7274-1c180afaadb2@huawei.com>
        <20210511163049.37d2cba0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <62054a31-4708-1696-60d5-b33e4993cddc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 May 2021 11:34:55 +0800 Yunsheng Lin wrote:
> > This is indeed the idiomatic way of dealing with Tx queue stopping race,
> > but it's a bit of code to sprinkle around. My vote would be option 1.  
> 
> I had done some performance testing to see which is better, tested using
> pktgen and dummy netdev with pfifo_fast qdisc attached:
> 
> unit: Mpps
> 
> threads    V6         V6 + option 1     V6 + option 3
>   1       2.60          2.54               2.60
>   2       3.86          3.84               3.84
>   4       5.56          5.50               5.51
>   8       2.79          2.77               2.77
>   16      2.23          2.24               2.22
> 
> So it seems the netif_xmit_frozen_or_stopped checking overhead for non-stopped queue
> is noticable for 1 pktgen thread.
> 
> And the performance increase for V6 + option 1 with 16 pktgen threads is because of
> "clear_bit(__QDISC_STATE_MISSED, &qdisc->state)" at the end of qdisc_run_end(), which
> may avoid the another round of dequeuing in the pfifo_fast_dequeue(). And adding the
> "clear_bit(__QDISC_STATE_MISSED, &qdisc->state)"  for V6 + option 3, the data for
> 16 pktgen thread also go up to 2.24Mpps.
> 
> 
> So it seems V6 + option 3 with "clear_bit(__QDISC_STATE_MISSED, &qdisc->state)" at
> the end of qdisc_run_end() is better?

Alright, sounds good.
