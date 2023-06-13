Return-Path: <netdev+bounces-10465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E706C72E9F7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73F3E2809C6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF2238CD2;
	Tue, 13 Jun 2023 17:36:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3764833E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108C9C433D9;
	Tue, 13 Jun 2023 17:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686677775;
	bh=yT/YcUbrOqFENj+tlyHyK738bYhHXlmlxIpioLPwxNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rsKT4uS9AZe+fe56mjdyH4mmF18zXzKHAWTiypuw4L4FlmNcloe/tEO3mgmU8ul+Z
	 ycS6v4BBbOoY9vJCs5Nivz20DPB0rQAxO0C4FWbZVgoOrjqpFWj1wNkFQzqVRnaZ3v
	 7NcAPUEpf2Vz2o0h979YmL+0fa9+vT8ay5Eym2y0R5BZage9kJJZ5TcnrE3HloHtyB
	 oHCv8KWsPajFqsfxtjoq6REYwNFQ+HmsGVXJPcoEi5c8Jkm66SACpJjHy43B847gSB
	 KvOU0+/V3L6G02M+zRgLeipDlnY185JSyTaLeo+a/mwBh1NI6AD8DKA8M39RJoXiKO
	 5gAtpZkwrATrQ==
Date: Tue, 13 Jun 2023 10:39:37 -0700
From: Bjorn Andersson <andersson@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH 03/26] phy: qcom: add the SGMII SerDes PHY driver
Message-ID: <20230613173937.fhk2cqcankg6oej6@ripper>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-4-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612092355.87937-4-brgl@bgdev.pl>

On Mon, Jun 12, 2023 at 11:23:32AM +0200, Bartosz Golaszewski wrote:
> diff --git a/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c b/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
[..]
> +static int qcom_dwmac_sgmii_phy_probe(struct platform_device *pdev)
> +{
> +	struct qcom_dwmac_sgmii_phy_data *data;
> +	struct device *dev = &pdev->dev;
> +	struct phy_provider *provider;
> +	struct clk *refclk;
> +	void __iomem *base;
> +	struct phy *phy;
> +
> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	base = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
> +	data->regmap = devm_regmap_init_mmio(dev, base,
> +					     &qcom_dwmac_sgmii_phy_regmap_cfg);
> +	if (IS_ERR(data->regmap))
> +		return PTR_ERR(data->regmap);
> +
> +	phy = devm_phy_create(dev, NULL, &qcom_dwmac_sgmii_phy_ops);
> +	if (IS_ERR(phy))
> +		return PTR_ERR(phy);
> +
> +	refclk = devm_clk_get_enabled(dev, "sgmi_ref");
> +	if (IS_ERR(refclk))
> +		return PTR_ERR(refclk);
> +
> +	provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +	if (IS_ERR(provider))
> +		return PTR_ERR(provider);
> +
> +	phy_set_drvdata(phy, data);
> +	platform_set_drvdata(pdev, data);

You don't use the pdev's dev's drvdata, so I think you can drop the
platform_set_drvdata()

Regards,
Bjorn

> +
> +	return 0;
> +}

