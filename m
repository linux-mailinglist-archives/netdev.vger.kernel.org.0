Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85721365198
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhDTErd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhDTErc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 00:47:32 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6223C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 21:46:57 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id i81so37786570oif.6
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 21:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UO9nTuCIT9hOADKmHVu9Q6LDo50ZfH52u0q+oxEEAHc=;
        b=j/5ZHSClavO58DdOR8CQCuVPItUEwUA4i9HSWSH2FvfvZiGzVKWn5cCZtAMeJJBNQa
         fcvpLt3NSoj1hwt9tNcGDNPny4tGaguD40VcvKxN7SpHPe94iQCR5o3Z7/UeIOVS8m0J
         l6QJmJ1SggSFttQsmZYTowtrpKmVMhr8k9PvsJiQ/gR01mU/kbjiS3icdp5mNLXRE0xD
         kXWCMzWLOSOKpcJ1tzkzgXjDFSw9Z4NzZzPUNo7wkJ9KVTqaUYCyC9NQ8pGr46bk81u6
         jACGdjOTH3LlpRHiiifXEWJixol54ep9ndNgfmM+VPbbwLpFHPRzssyZjr7ej/yHTPkB
         jDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=UO9nTuCIT9hOADKmHVu9Q6LDo50ZfH52u0q+oxEEAHc=;
        b=lvi+zbpTPExLUK7mJcGZpRgoMW348x8t1iLFs2fq8qeEXd0pzc22SGJmegjIeyyNig
         qOcfrtx8ElTbLZeTBB0LScXBtIbHV2vijIp6Jq4RbZOrwryg9ikjCdPl9w3e/i5zlrUe
         /buhkMdZjvPdJzo0x4cxvZIhBS1ft0CBOGWihbbz3s2CoJUZXrUtYkOH/XWmJXRQWLkE
         weVWl5ghBLOHdfw+Mhk95hlzFjUgxBxrzpfTM+PpEHImQCUHqiW9ExwpWJJ1sDBKvZlq
         D8L4Btq9RmFNjjIP6oyWnO5e3RDLecg0JGZ0VyHikcD/dcnmTtv0UVA/O5pBSa1i+e7X
         zh8A==
X-Gm-Message-State: AOAM532Qf1AfGA7z5AMA7YcUreJ4rJxK2tVVMeSoL6noN7W2RfltrLn7
        1Bs9mUOIiBZ85uheAb8sV4UtytIe0rY=
X-Google-Smtp-Source: ABdhPJxADw0CenHCjbN9MQoMQ26Fd9xaAM4JGpqTObX2mFtMlTzju/EXU9GsK2Iiw6IEKPkSZB0Y6A==
X-Received: by 2002:aca:4791:: with SMTP id u139mr1753600oia.83.1618894017330;
        Mon, 19 Apr 2021 21:46:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a73sm2098261oib.23.2021.04.19.21.46.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Apr 2021 21:46:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 19 Apr 2021 21:46:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [net-next, v2] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
Message-ID: <20210420044655.GA144160@roeck-us.net>
References: <20210414015221.87554-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414015221.87554-1-xuanzhuo@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 09:52:21AM +0800, Xuan Zhuo wrote:
> In page_to_skb(), if we have enough tailroom to save skb_shared_info, we
> can use build_skb to create skb directly. No need to alloc for
> additional space. And it can save a 'frags slot', which is very friendly
> to GRO.
> 
> Here, if the payload of the received package is too small (less than
> GOOD_COPY_LEN), we still choose to copy it directly to the space got by
> napi_alloc_skb. So we can reuse these pages.
> 
> Testing Machine:
>     The four queues of the network card are bound to the cpu1.
> 
> Test command:
>     for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done
> 
> The size of the udp package is 1000, so in the case of this patch, there
> will always be enough tailroom to use build_skb. The sent udp packet
> will be discarded because there is no port to receive it. The irqsoftd
> of the machine is 100%, we observe the received quantity displayed by
> sar -n DEV 1:
> 
> no build_skb:  956864.00 rxpck/s
> build_skb:    1158465.00 rxpck/s
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>

Booting qemu-system-alpha with virtio-net interface instantiated results in:

udhcpc: sending discover
Unable to handle kernel paging request at virtual address 0000000000000004
udhcpc(169): Oops -1
pc = [<0000000000000004>]  ra = [<fffffc0000b8c588>]  ps = 0000    Not tainted
pc is at 0x4
ra is at napi_gro_receive+0x68/0x150
v0 = 0000000000000000  t0 = 0000000000000008  t1 = 0000000000000000
t2 = 0000000000000000  t3 = 000000000000000e  t4 = 0000000000000038
t5 = 000000000000ffff  t6 = fffffc00002f220a  t7 = fffffc0002cd0000
s0 = fffffc00010b3ca0  s1 = 0000000000000000  s2 = fffffc00011267e0
s3 = 0000000000000000  s4 = fffffc00025f2008  s5 = fffffc00002f21c0
s6 = fffffc00025f2040
a0 = fffffc00025f2008  a1 = fffffc00002f21c0  a2 = fffffc0002cc800c
a3 = fffffc00000250d0  a4 = 0000000effff0008  a5 = 0000000000000000
t8 = fffffc00010b3c80  t9 = fffffc0002cc84cc  t10= 0000000000000000
t11= 00000000000004c0  pv = fffffc0000b8bc10  at = 0000000000000000
gp = fffffc00010f9fb8  sp = 00000000aefe3f8a
Disabling lock debugging due to kernel taint
Trace:
[<fffffc0000b8c588>] napi_gro_receive+0x68/0x150
[<fffffc00009b406c>] receive_buf+0x50c/0x1b80
[<fffffc00009b5888>] virtnet_poll+0x1a8/0x5b0
[<fffffc00009b58bc>] virtnet_poll+0x1dc/0x5b0
[<fffffc0000b8d14c>] __napi_poll+0x4c/0x270
[<fffffc0000b8d640>] net_rx_action+0x130/0x2c0
[<fffffc0000bd6f00>] __qdisc_run+0x90/0x6c0
[<fffffc0000337b64>] do_softirq+0xa4/0xd0
[<fffffc0000337ca4>] __local_bh_enable_ip+0x114/0x120
[<fffffc0000b89524>] __dev_queue_xmit+0x484/0xa60
[<fffffc0000cd06fc>] packet_sendmsg+0xe7c/0x1ba0
[<fffffc0000b53308>] __sys_sendto+0xf8/0x170
[<fffffc0000461440>] __d_alloc+0x40/0x270
[<fffffc0000ccdc4c>] packet_create+0x17c/0x3c0
[<fffffc0000b5218c>] move_addr_to_kernel+0x3c/0x60
[<fffffc0000b532b4>] __sys_sendto+0xa4/0x170
[<fffffc0000b533a4>] sys_sendto+0x24/0x40
[<fffffc0000b52840>] sys_bind+0x20/0x40
[<fffffc0000311514>] entSys+0xa4/0xc0

Bisect log attached.

Guenter

---
# bad: [50b8b1d699ac313c0a07a3c185ffb23aecab8abb] Add linux-next specific files for 20210419
# good: [bf05bf16c76bb44ab5156223e1e58e26dfe30a88] Linux 5.12-rc8
git bisect start 'HEAD' 'v5.12-rc8'
# bad: [c4bb91fc07e59241cde97f913d7a2fbedc248f0d] Merge remote-tracking branch 'crypto/master'
git bisect bad c4bb91fc07e59241cde97f913d7a2fbedc248f0d
# good: [499f739ad70f2a58aac985dceb25ca7666da88be] Merge remote-tracking branch 'jc_docs/docs-next'
git bisect good 499f739ad70f2a58aac985dceb25ca7666da88be
# good: [17e1be342d46eb0b7c3df4c7e623493483080b63] bnxt_en: Treat health register value 0 as valid in bnxt_try_reover_fw().
git bisect good 17e1be342d46eb0b7c3df4c7e623493483080b63
# good: [cf6d6925625755029cdf4bb0d0028f0b6e713242] Merge remote-tracking branch 'rdma/for-next'
git bisect good cf6d6925625755029cdf4bb0d0028f0b6e713242
# good: [fb8517f4fade44fa5e42e29ca4d6e4a7ed50b512] rtw88: 8822c: add CFO tracking
git bisect good fb8517f4fade44fa5e42e29ca4d6e4a7ed50b512
# bad: [d168b61fb769d10306b6118ec7623d2911d45690] Merge remote-tracking branch 'gfs2/for-next'
git bisect bad d168b61fb769d10306b6118ec7623d2911d45690
# bad: [ee3e875f10fca68fb7478c23c75b553e56da319c] net: enetc: increase TX ring size
git bisect bad ee3e875f10fca68fb7478c23c75b553e56da319c
# good: [4a51b0e8a0143b0e83d51d9c58c6416c3818a9f2] r8152: support PHY firmware for RTL8156 series
git bisect good 4a51b0e8a0143b0e83d51d9c58c6416c3818a9f2
# bad: [03e481e88b194296defdff3600b2fcebb04bd6cf] Merge tag 'mlx5-updates-2021-04-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
git bisect bad 03e481e88b194296defdff3600b2fcebb04bd6cf
# bad: [70c183759b2cece2f9ba82e63e38fa32bebc9db2] Merge branch 'gianfar-mq-polling'
git bisect bad 70c183759b2cece2f9ba82e63e38fa32bebc9db2
# bad: [d8604b209e9b3762280b8321162f0f64219d51c9] dt-bindings: net: qcom,ipa: add firmware-name property
git bisect bad d8604b209e9b3762280b8321162f0f64219d51c9
# good: [4ad29b1a484e0c58acfffdcd87172ed17f35c1dd] net: mvpp2: Add parsing support for different IPv4 IHL values
git bisect good 4ad29b1a484e0c58acfffdcd87172ed17f35c1dd
# good: [fa588eba632df14d296436995e6bbea0c146ae77] net: Add Qcom WWAN control driver
git bisect good fa588eba632df14d296436995e6bbea0c146ae77
# bad: [fb32856b16ad9d5bcd75b76a274e2c515ac7b9d7] virtio-net: page_to_skb() use build_skb when there's sufficient tailroom
git bisect bad fb32856b16ad9d5bcd75b76a274e2c515ac7b9d7
# first bad commit: [fb32856b16ad9d5bcd75b76a274e2c515ac7b9d7] virtio-net: page_to_skb() use build_skb when there's sufficient tailroom
