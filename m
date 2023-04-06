Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A072C6D9223
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbjDFI6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235743AbjDFI6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B165B88
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680771437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srqW/Zc6uyMlDdpAQsQE29ZbVva96BUjEhTIphyrjK4=;
        b=cGQLijeXAwaotJj8sYX2LMskkFkIkr0eszku0KHVQ4S7g+hUwbxR9s5zDdfqtWsPskx+wV
        Wl3vjgkWz9It10d0Thgc9uhwJ5Iv+SccvwhxE6aJH9wj8Gv5qP25ucnGtPiHS8iKklHFUK
        pn9Ks1D8XIfUYa3Aq9F8hd3UY5uDa+c=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-5ZvFc56IPa-Se5OvOdfsmA-1; Thu, 06 Apr 2023 04:57:16 -0400
X-MC-Unique: 5ZvFc56IPa-Se5OvOdfsmA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3e2daffa0d4so13711711cf.0
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680771435;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=srqW/Zc6uyMlDdpAQsQE29ZbVva96BUjEhTIphyrjK4=;
        b=5x4IHUHTcH7URSbcqVMxXatFqcRsorHvVLdElcm7oRmheuAjoviWmwZ25DGhMDBGW9
         I15DqgSiYGZkmLq5is0LnZqwhlqj5bRFDzO8C37ELJ0Se4/aw1jlQxK4M6+IjZNdjn8D
         WCJyucvvQzoRT6CoAHM7Q9hwE9SD0q1lLw3lZvG9Gx47Vx2ZdjVxE49wMs79ot4Kn03y
         1P42iTsdsbI9AeNfrySgkE7qS5Y7pz1JqpjbEa9KYbUbzndUcZq6rTxtU/qv8sDRWKbJ
         iPmQA3CIfXdrPt4LAjRjnmfVQrebyLOQbrbJprwekBNf4tpK2CIauNnucBZ5rCIaH2vF
         XLOw==
X-Gm-Message-State: AAQBX9eyWKUeFyZeGTlXv22lVS8HCD8ldaZ5QEOvx2kT4lvH6SJVxA5o
        Yfd6hU0EI1zWps9My9xnUvYUH17IxeTpInxYSUksbhP9sxgfxZISN+zDwCluxdCEsN8ffOGkvnN
        J1xsv4WPWZLTFsZ+l
X-Received: by 2002:a05:622a:1815:b0:3e4:eb39:eb8b with SMTP id t21-20020a05622a181500b003e4eb39eb8bmr11113069qtc.5.1680771435674;
        Thu, 06 Apr 2023 01:57:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350bzXKpcq5d/id+6ZQprS3naXkWcpRtP62YORjWExdv5Im2GPPasqjiU0Vii9Sx8y+GhdWYImw==
X-Received: by 2002:a05:622a:1815:b0:3e4:eb39:eb8b with SMTP id t21-20020a05622a181500b003e4eb39eb8bmr11113044qtc.5.1680771435377;
        Thu, 06 Apr 2023 01:57:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id 15-20020a05620a040f00b0073b8512d2dbsm318849qkp.72.2023.04.06.01.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:57:15 -0700 (PDT)
Message-ID: <d9f969cfc020a29a4ad74d3726c1fc322f8eb9a8.camel@redhat.com>
Subject: Re: [PATCH net-next v3 12/12] net: stmmac: dwmac-qcom-ethqos: Add
 EMAC3 support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        mturquette@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Date:   Thu, 06 Apr 2023 10:57:08 +0200
In-Reply-To: <20230403165229.4jhpo2xs7tuclekw@halaney-x13s>
References: <20230331214549.756660-1-ahalaney@redhat.com>
         <20230403165229.4jhpo2xs7tuclekw@halaney-x13s>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2023-04-03 at 11:52 -0500, Andrew Halaney wrote:
> @@ -327,9 +370,17 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqo=
s *ethqos)
>  			      RGMII_CONFIG2_RX_PROG_SWAP,
>  			      RGMII_IO_MACRO_CONFIG2);
> =20
> -		/* Set PRG_RCLK_DLY to 57 for 1.8 ns delay */
> -		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_RCLK_DLY,
> -			      57, SDCC_HC_REG_DDR_CONFIG);
> +		/* PRG_RCLK_DLY =3D TCXO period * TCXO_CYCLES_CNT / 2 * RX delay ns,
> +		 * in practice this becomes PRG_RCLK_DLY =3D 52 * 4 / 2 * RX delay ns
> +		 */
> +		if (ethqos->has_emac3)
> +			/* 0.9 ns */
> +			rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_RCLK_DLY,
> +				      115, SDCC_HC_REG_DDR_CONFIG);
> +		else
> +			/* 1.8 ns */
> +			rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_RCLK_DLY,
> +				      57, SDCC_HC_REG_DDR_CONFIG);

The only (very minor) comment I have is that AFAIK the preferred style
for the above block is:=20

		if (ethqos->has_emac3) {
			/* 0.9 ns */
			rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_RCLK_DLY,
				      115, SDCC_HC_REG_DDR_CONFIG);
		} else {
			...

due to the comment presence this should be threaded as a multi-line stateme=
nt.
(even if checkpatch does not complain).

Cheers,

Paolo

>  			      SDCC_HC_REG_DDR_CONFIG);
> @@ -355,8 +406,15 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqo=
s *ethqos)
>  			      BIT(6), RGMII_IO_MACRO_CONFIG);
>  		rgmii_updatel(ethqos, RGMII_CONFIG2_RSVD_CONFIG15,
>  			      0, RGMII_IO_MACRO_CONFIG2);
> -		rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
> -			      0, RGMII_IO_MACRO_CONFIG2);
> +
> +		if (ethqos->has_emac3)
> +			rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
> +				      RGMII_CONFIG2_RX_PROG_SWAP,
> +				      RGMII_IO_MACRO_CONFIG2);
> +		else
> +			rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
> +				      0, RGMII_IO_MACRO_CONFIG2);
> +
>  		/* Write 0x5 to PRG_RCLK_DLY_CODE */
>  		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_CODE,
>  			      (BIT(29) | BIT(27)), SDCC_HC_REG_DDR_CONFIG);
> @@ -389,8 +447,13 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqo=
s *ethqos)
>  			      RGMII_IO_MACRO_CONFIG);
>  		rgmii_updatel(ethqos, RGMII_CONFIG2_RSVD_CONFIG15,
>  			      0, RGMII_IO_MACRO_CONFIG2);
> -		rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
> -			      0, RGMII_IO_MACRO_CONFIG2);
> +		if (ethqos->has_emac3)
> +			rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
> +				      RGMII_CONFIG2_RX_PROG_SWAP,
> +				      RGMII_IO_MACRO_CONFIG2);
> +		else
> +			rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
> +				      0, RGMII_IO_MACRO_CONFIG2);
>  		/* Write 0x5 to PRG_RCLK_DLY_CODE */
>  		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_CODE,
>  			      (BIT(29) | BIT(27)), SDCC_HC_REG_DDR_CONFIG);
> @@ -433,6 +496,17 @@ static int ethqos_configure(struct qcom_ethqos *ethq=
os)
>  	rgmii_updatel(ethqos, SDCC_DLL_CONFIG_PDN,
>  		      SDCC_DLL_CONFIG_PDN, SDCC_HC_REG_DLL_CONFIG);
> =20
> +	if (ethqos->has_emac3) {
> +		if (ethqos->speed =3D=3D SPEED_1000) {
> +			rgmii_writel(ethqos, 0x1800000, SDCC_TEST_CTL);
> +			rgmii_writel(ethqos, 0x2C010800, SDCC_USR_CTL);
> +			rgmii_writel(ethqos, 0xA001, SDCC_HC_REG_DLL_CONFIG2);
> +		} else {
> +			rgmii_writel(ethqos, 0x40010800, SDCC_USR_CTL);
> +			rgmii_writel(ethqos, 0xA001, SDCC_HC_REG_DLL_CONFIG2);
> +		}
> +	}
> +
>  	/* Clear DLL_RST */
>  	rgmii_updatel(ethqos, SDCC_DLL_CONFIG_DLL_RST, 0,
>  		      SDCC_HC_REG_DLL_CONFIG);
> @@ -452,7 +526,9 @@ static int ethqos_configure(struct qcom_ethqos *ethqo=
s)
>  			      SDCC_HC_REG_DLL_CONFIG);
> =20
>  		/* Set USR_CTL bit 26 with mask of 3 bits */
> -		rgmii_updatel(ethqos, GENMASK(26, 24), BIT(26), SDCC_USR_CTL);
> +		if (!ethqos->has_emac3)
> +			rgmii_updatel(ethqos, GENMASK(26, 24), BIT(26),
> +				      SDCC_USR_CTL);
> =20
>  		/* wait for DLL LOCK */
>  		do {
> @@ -547,6 +623,7 @@ static int qcom_ethqos_probe(struct platform_device *=
pdev)
>  	ethqos->por =3D data->por;
>  	ethqos->num_por =3D data->num_por;
>  	ethqos->rgmii_config_loopback_en =3D data->rgmii_config_loopback_en;
> +	ethqos->has_emac3 =3D data->has_emac3;
> =20
>  	ethqos->rgmii_clk =3D devm_clk_get(&pdev->dev, "rgmii");
>  	if (IS_ERR(ethqos->rgmii_clk)) {
> @@ -566,6 +643,7 @@ static int qcom_ethqos_probe(struct platform_device *=
pdev)
>  	plat_dat->fix_mac_speed =3D ethqos_fix_mac_speed;
>  	plat_dat->dump_debug_regs =3D rgmii_dump;
>  	plat_dat->has_gmac4 =3D 1;
> +	plat_dat->dwmac4_addrs =3D &data->dwmac4_addrs;
>  	plat_dat->pmt =3D 1;
>  	plat_dat->tso_en =3D of_property_read_bool(np, "snps,tso");
>  	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
> @@ -603,6 +681,7 @@ static int qcom_ethqos_remove(struct platform_device =
*pdev)
> =20
>  static const struct of_device_id qcom_ethqos_match[] =3D {
>  	{ .compatible =3D "qcom,qcs404-ethqos", .data =3D &emac_v2_3_0_data},
> +	{ .compatible =3D "qcom,sc8280xp-ethqos", .data =3D &emac_v3_0_0_data},
>  	{ .compatible =3D "qcom,sm8150-ethqos", .data =3D &emac_v2_1_0_data},
>  	{ }
>  };

