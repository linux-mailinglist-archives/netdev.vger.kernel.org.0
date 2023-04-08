Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D556DB868
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 04:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjDHC5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 22:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDHC5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 22:57:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F09D50F
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 19:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B8A6125B
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 02:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A94C433D2;
        Sat,  8 Apr 2023 02:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680922652;
        bh=iP8ZWnwE0T7PXtn7EQ51ZN7kOpLNp41+kNEFR32XrEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qO4e+GkE8r2CQ7Z32n0cj8YH9qsjSTGzwi7wxYdiZFkYbAimRaCN+8tr1y32nqWIa
         HFXrH99fE2PF/+56nZxSk1CZNIrSKhOjoSvkDKsAmdPQDq6X0Ei1GT+N+CpJKCGySY
         ZpZRMFHO0AHi7GTb61W3zBM8AQLmWitf8+Ng1//9UoGi6BR8oq6IaVBDkP61PLKpgS
         w0cw4v/u5sXRHoFmQFJ7yctI6C3N5co7KRIEfnZpRVjJ+YaNlXDxvdMpF3xdWNkcx7
         JA+jb4QLCqd77cQLykn6JFJo5h+tGa/ojKjiVMUx1kjrhL+CO5KuMZFNqbA8MK3ayF
         MUZWcd/ZMe89w==
Date:   Fri, 7 Apr 2023 19:57:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     louts <rocklouts@sina.com>
Cc:     davem@davemloft.net, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com, edumazet@google.com,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: fix system hang when setting up standalone
 tag_8021q VLAN for DSA ports
Message-ID: <20230407195730.298867dd@kernel.org>
In-Reply-To: <20230406100437.5402-1-rocklouts@sina.com>
References: <20230406100437.5402-1-rocklouts@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Apr 2023 18:04:37 +0800 louts wrote:
> The system hang because of dsa_tag_8021q_port_setup() callbcak
> stmmac_vlan_rx_add_vid().I found in stmmac_drv_probe() that
> cailing pm_runtime_put() disabled the clock when check the stmmac
> dirver.
>=20
> First, when the kernel is compiled with CONFIG_PM=3Dy,The stmmac's
> resume/suspend is active.
>=20
> Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
> will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
> The system is hanged for the stmmac_vlan_rx_add_vid()  accesses its
> registers after stmmac's clock is closed.
>=20
> I would suggest adding the pm_runtime_resume_and_get() to the
> stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
> while in use.
>=20
> Signed-off-by: louts <rocklouts@sina.com>

Is that your full name? If your name is not in the Latin alphabet
feel free to put it in brackets after the Latin version, e.g.:

Signed-off-by: John (=D1=8F=D0=BA=D0=B5=D1=81=D1=8C =D1=96=D0=BC'=D1=8F) <j=
ohn@bla.abc>

> @@ -6198,16 +6202,19 @@ static int stmmac_vlan_rx_add_vid(struct net_devi=
ce *ndev, __be16 proto, u16 vid
>  	ret =3D stmmac_vlan_update(priv, is_double);
>  	if (ret) {
>  		clear_bit(vid, priv->active_vlans);
> -		return ret;
> +		goto update_vlan_error;
>  	}
> =20
>  	if (priv->hw->num_vlan) {
>  		ret =3D stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
>  		if (ret)
> -			return ret;
> +			goto add_vlan_error;
>  	}
> +update_vlan_error:
> +add_vlan_error:

Name the labels after the target please.

err_pm_put:

> +	pm_runtime_put(priv->device);
> =20
> -	return 0;
> +	return ret;
