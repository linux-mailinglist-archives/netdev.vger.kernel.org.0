Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006C02EFD15
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 03:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbhAICNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 21:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbhAICNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 21:13:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8235B238EC;
        Sat,  9 Jan 2021 02:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610158370;
        bh=XXUIcNwszl/AeCtfTEw05DcsVnxXHvH6qYPb0Q33W3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JXShqtvmgf7Z0zkEIIATllIrNqir0kuWKMgYC2rBAr1WLcxpTQu/2dk1fuZZPlctT
         ZS60ka7aJVyrAAG94j3ZdeMPJfZ1x10rvzbgESDJlrdMstf8OdutUNcZb/aHuA/Kd2
         D5AwjzdBAY8oiMmm+cIEj3IL7/MT/GrDKxrvryWhQNz7cNHfPIGnsQRusW1ANcgRUw
         hChQSqO9N7SQjevsPhvwkmQVRIJ8Jyhqr97zoIYZb3+AntasXOkmDZCnukDsf9LLbC
         ITFtPDqP0beEZx2Uz1F6pibj0xe81yKOSjtW1yKUa3IG8ACBpdD25ss/hz9OiHjgT8
         PR8lrN+SuGv0A==
Date:   Fri, 8 Jan 2021 18:12:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: [PATCH net] cxgb4/chtls: Fix tid stuck due to wrong update of
 qid
Message-ID: <20210108181249.116682c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108175914.18876-1-ayush.sawal@chelsio.com>
References: <20210108175914.18876-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jan 2021 23:29:14 +0530 Ayush Sawal wrote:
> +void chtls_set_quiesce_ctrl(struct sock *sk, int val)
> +{
> +	struct chtls_sock *csk;
> +	struct sk_buff *skb;
> +	unsigned int wrlen;
> +	unsigned int len;
> +	int ret;
> +
> +	wrlen =3D sizeof(struct cpl_set_tcb_field) + sizeof(struct ulptx_idata);
> +	wrlen =3D roundup(wrlen, 16);
> +
> +	skb =3D alloc_skb(wrlen, GFP_ATOMIC);
> +	if (!skb)
> +		return;
> +
> +	csk =3D rcu_dereference_sk_user_data(sk);
> +
> +	__set_tcb_field(sk, skb, 1, TF_RX_QUIESCE_V(1), 0, 0, 1);
> +	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->port_id);
> +	ret =3D cxgb4_ofld_send(csk->egress_dev, skb);
> +	if (ret < 0)
> +		kfree_skb(skb);
> +}

drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c: In function =
=E2=80=98chtls_set_quiesce_ctrl=E2=80=99:
drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c:139:15: warning=
: unused variable =E2=80=98len=E2=80=99 [-Wunused-variable]
  139 |  unsigned int len;
      |               ^~~
