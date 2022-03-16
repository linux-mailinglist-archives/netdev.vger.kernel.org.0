Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C277C4DA73C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 02:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351693AbiCPBLN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Mar 2022 21:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiCPBLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 21:11:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB7A43EE2;
        Tue, 15 Mar 2022 18:09:58 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KJBwD1GD5zCqjR;
        Wed, 16 Mar 2022 09:07:56 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 09:09:56 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2308.021;
 Wed, 16 Mar 2022 09:09:56 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Martin KaFai Lau <kafai@fb.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH bpf-next] net: Use skb->len to check the validity of the
 parameters in bpf_skb_load_bytes
Thread-Topic: [PATCH bpf-next] net: Use skb->len to check the validity of the
 parameters in bpf_skb_load_bytes
Thread-Index: AQHYOGk2O/XwDW4Ml0q7jRHCigZ/yqzAVx0AgADbdhA=
Date:   Wed, 16 Mar 2022 01:09:56 +0000
Message-ID: <4f937ace70a3458580c6242fa68ea549@huawei.com>
References: <20220315123916.110409-1-liujian56@huawei.com>
 <20220315195822.sonic5avyizrufsv@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220315195822.sonic5avyizrufsv@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin KaFai Lau [mailto:kafai@fb.com]
> Sent: Wednesday, March 16, 2022 3:58 AM
> To: liujian (CE) <liujian56@huawei.com>
> Cc: ast@kernel.org; daniel@iogearbox.net; andrii@kernel.org;
> songliubraving@fb.com; yhs@fb.com; john.fastabend@gmail.com;
> kpsingh@kernel.org; davem@davemloft.net; kuba@kernel.org;
> sdf@google.com; netdev@vger.kernel.org; bpf@vger.kernel.org
> Subject: Re: [PATCH bpf-next] net: Use skb->len to check the validity of the
> parameters in bpf_skb_load_bytes
> 
> On Tue, Mar 15, 2022 at 08:39:16PM +0800, Liu Jian wrote:
> > The data length of skb frags + frag_list may be greater than 0xffff,
> > so here use skb->len to check the validity of the parameters.
> What is the use case that needs to look beyond 0xffff ?
I use sockmap with strparser, the stm->strp.offset (the begin of one application layer protocol message) maybe beyond 0xffff, but i need load the message head to do something.
