Return-Path: <netdev+bounces-10139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49AA872C82B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60DFC1C20B1C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C0E1B909;
	Mon, 12 Jun 2023 14:23:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3677419E4B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:23:23 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2103B2971;
	Mon, 12 Jun 2023 07:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=7U3S3aDXoyTe2VWHCo8a2sFvGLCKSxzv9wHr91KGNO0=; b=mlMG+USSqkhzb3tGNwmjg/3lgb
	4s16zRKqyQci5db2fSOF3t8ekrg210WhvpedpUECrF0jpYaUTIqS6+3ePiRGv/Fw2FN1r3UAFprc4
	+Udzz3gZNf3f/jOU0IaBLMtOf0qnj/vsqg2XjzAFWLDDZsxwYClVql3A1TdzjEpTRTvk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q8iQw-00Fc9V-I2; Mon, 12 Jun 2023 16:22:14 +0200
Date: Mon, 12 Jun 2023 16:22:14 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc: richardcochran@gmail.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, vincent.cheng.xh@renesas.com,
	harini.katakam@amd.com, git@amd.com
Subject: Re: [PATCH] ptp: clockmatrix: Add Defer probe if firmware load fails
Message-ID: <9886bdc0-31be-4153-9b19-6dc53b0b8b5b@lunn.ch>
References: <20230612100044.979281-1-sarath.babu.naidu.gaddam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612100044.979281-1-sarath.babu.naidu.gaddam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 03:30:44PM +0530, Sarath Babu Naidu Gaddam wrote:
> Clock matrix driver can be probed before the rootfs containing
> firmware/initialization .bin is available. The current driver
> throws a warning and proceeds to execute probe even when firmware
> is not ready. Instead, defer probe and wait for the .bin file to
> be available.
> 
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
>  drivers/ptp/ptp_clockmatrix.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
> index c9d451bf89e2..96328dfb7e55 100644
> --- a/drivers/ptp/ptp_clockmatrix.c
> +++ b/drivers/ptp/ptp_clockmatrix.c
> @@ -2424,9 +2424,13 @@ static int idtcm_probe(struct platform_device *pdev)
>  
>  	err = idtcm_load_firmware(idtcm, &pdev->dev);
>  
> -	if (err)
> +	if (err) {
>  		dev_warn(idtcm->dev, "loading firmware failed with %d", err);
>  
> +		if (err == -ENOENT)
> +			return -EPROBE_DEFER;
> +	}

Maybe move the dev_warn() after the test so you don't spam the logs
with failures which are not yet real failures?

     Andrew

