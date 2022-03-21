Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6C64E2A7A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 15:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349094AbiCUO0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 10:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352028AbiCUOX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 10:23:58 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABF02981A
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 07:18:45 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22LACps6029509;
        Mon, 21 Mar 2022 07:18:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=hfNdan4lHL/Fs86juFnFGAn/QUvAV0P9DxN7QtP/JGU=;
 b=AT1uOJ7uT0KuREJE/oC03oyksAijU+hwVyKIR518Odza6U3jnGjeSojWNeEWReqZVewh
 N99ISRnUAG1NyTWScL8+1X/8N3GHPkfOxZiTLUwuhCZroBI63GzQM5OXJhQBnsKb//+U
 is4yvqFSRskIWgD9mqFMtsY/U+J/oBFxhbbIYrd06qvYLMX5JuA5g1u8xdBtleptty3D
 BHoGHP2r4D7sAxSMNpf3blWHBn6VTfsOfoGJ/iSBPpo34dpTl0BlarxqS+xptCc3aa6t
 7o4ub8R9MlmnoTLbRr4qcZBI8Xj0S9q/cKZX4R3iI408Foyh+ZCZ3hnU+MWCEb4fWleG Zw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ewepmyr5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 07:18:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Mar
 2022 07:18:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 21 Mar 2022 07:18:38 -0700
Received: from [10.193.34.141] (unknown [10.193.34.141])
        by maili.marvell.com (Postfix) with ESMTP id 20EC23F704E;
        Mon, 21 Mar 2022 07:18:36 -0700 (PDT)
Message-ID: <5067f1b9-2257-226c-4f58-4079d407a161@marvell.com>
Date:   Mon, 21 Mar 2022 15:18:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [PATCH net-next v2 2/3] net: atlantic: Implement xdp data plane
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20220319140443.6645-1-ap420073@gmail.com>
 <20220319140443.6645-3-ap420073@gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20220319140443.6645-3-ap420073@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: v_rr-F-1oHWKtst_nnejp663YxUkQbiv
X-Proofpoint-GUID: v_rr-F-1oHWKtst_nnejp663YxUkQbiv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_06,2022-03-21_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Taehee,

Thanks for taking care of that!
Just for your information - I've started xdp draft sometime ago,
but never had a time to complete it.
If interested, you can check it here:
https://github.com/Aquantia/AQtion/commit/165cc46cb3fa68eca3110d846db1744a0feee916 

Couple of comments on your implementation follows.

On 3/19/2022 3:04 PM, Taehee Yoo wrote:
> It supports XDP_PASS, XDP_DROP and multi buffer.
> 
> From now on aq_nic_map_skb() supports xdp_frame to send packet.
> So, TX path of both skb and xdp_frame can use aq_nic_map_skb().
> aq_nic_xmit() is used to send packet with skb and internally it
> calls aq_nic_map_skb(). aq_nic_xmit_xdpf() is used to send packet with
> xdp_frame and internally it calls aq_nic_map_skb().

>  unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
> -			    struct aq_ring_s *ring)
> +			    struct xdp_frame *xdpf, struct aq_ring_s
> *ring)
>  {

Its not a huge problem, but here you are using one function (aq_nic_map_skb) with two
completely separate paths: either skb != NULL or xdpf != NULL.
This makes the function abit cumbersome and error prone.

> +	if (xdpf) {
> +		sinfo = xdp_get_shared_info_from_frame(xdpf);
> +		total_len = xdpf->len;
> +		dx_buff->len = total_len;
> +		data_ptr = xdpf->data;
> +		if (xdp_frame_has_frags(xdpf)) {
> +			nr_frags = sinfo->nr_frags;
> +			total_len += sinfo->xdp_frags_size;
> +		}
> +		goto start_xdp;

May be instead of doing this jump - just introduce a separate function
like `aq_map_xdp` specially for xdp case.

> +int aq_ring_rx_clean(struct aq_ring_s *self,
> +		     struct napi_struct *napi,
> +		     int *work_done,
> +		     int budget)
> +{
> +	if (static_branch_unlikely(&aq_xdp_locking_key))
> +		return __aq_ring_xdp_clean(self, napi, work_done, budget);
> +	else
> +		return __aq_ring_rx_clean(self, napi, work_done, budget);
> +}

Is that really required to split into `xdp_clean` and `rx_clean` ?
They are very similar, may be try to unify?

Regards,
  Igor
