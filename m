Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DC0260525
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgIGTcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728879AbgIGTco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 15:32:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DC0F2145D;
        Mon,  7 Sep 2020 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599507163;
        bh=g+Xuhro+2C6jeU2SaqGnGSXANVvt/STb+HmWaf8GMs4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jvc/WVyWVVkX7Oiqij0df2r4OmV818Ugg4hnSBDCuc8GFrUI3KBa+kmd5mx8BBpJ6
         BdCi37GOMcMFPqs0qoRGCAwzsyqmk9ygp8hkNwCrv+/tuasMRYFZbQ4XjL/lq1sT4o
         jXlGN+P8IZTp7SsinI/CXaow4DcFO52544ijn1QY=
Date:   Mon, 7 Sep 2020 12:32:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next 4/4] ixgbe, xsk: use XSK_NAPI_WEIGHT as NAPI
 poll budget
Message-ID: <20200907123241.447371e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907150217.30888-5-bjorn.topel@gmail.com>
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
        <20200907150217.30888-5-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Sep 2020 17:02:17 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
> zero-copy path.
>=20
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_xsk.c
> index 3771857cf887..f32c1ba0d237 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -239,7 +239,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_ve=
ctor,
>  	bool failure =3D false;
>  	struct sk_buff *skb;
> =20
> -	while (likely(total_rx_packets < budget)) {
> +	while (likely(total_rx_packets < XSK_NAPI_WEIGHT)) {

I was thinking that we'd multiply 'budget' here, not replace it with a
constant. Looks like ixgbe dutifully passes 'per_ring_budget' into the
clean_rx functions, not a complete NAPI budget.

>  		union ixgbe_adv_rx_desc *rx_desc;
>  		struct ixgbe_rx_buffer *bi;
>  		unsigned int size;

