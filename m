Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9626D00B9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjC3KKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjC3KKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:10:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518E27DB2;
        Thu, 30 Mar 2023 03:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8298B8258A;
        Thu, 30 Mar 2023 10:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD83C433D2;
        Thu, 30 Mar 2023 10:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680171040;
        bh=NXNwGsAYLBsQY9dA06ZnOE2S68dF14Wy6ldja64Ce0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P8RuF43lX0HN67shTTXKZj0DzpruL+7nrAV5z1JxfN3TdehDEFeD/FFubfbzgAIMN
         0CSG41hSJrtylhO0ylPmwChpwgZ/bYgPtIHg5JTzOeNmFzXug2qVqCMymMi7HVYQfn
         WNwi6X1b07GeWa8wW3ckdJTxMB1CHYJPwXnt412g1H+I9k/pQlUz2uriJ7Sva+3/d5
         /H1R1B3jxtHGoTksEpxFbnvMartPgwkxXuy/pLE0yih+nDS4o+0kGPnd+nlg7KoWia
         w+ch6UaCfYtjygcofaFXx5BH0bAwdOiWcwbk3rc4SOeiHicb7OUPJCij8pp54JseeV
         EdjwFWJsIES+w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1phpFC-0005NY-Gj; Thu, 30 Mar 2023 12:10:58 +0200
Date:   Thu, 30 Mar 2023 12:10:58 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v8 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Message-ID: <ZCVgMuSdyMQhf/Ko@hovoldconsulting.com>
References: <20230326233812.28058-1-steev@kali.org>
 <20230326233812.28058-3-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326233812.28058-3-steev@kali.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 06:38:10PM -0500, Steev Klimaszewski wrote:
> Add regulators, GPIOs and changes required to power on/off wcn6855.
> Add support for firmware download for wcn6855 which is in the
> linux-firmware repository as hpbtfw21.tlv and hpnv21.bin.
> 
> Based on the assumption that this is similar to the wcn6750
> 
> Tested-on: BTFW.HSP.2.1.0-00538-VER_PATCHZ-1
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> Tested-by: Bjorn Andersson <andersson@kernel.org>
> ---
> Changes since v7:
>  * None

Only noticed now when Luiz applied the patches, but why did you drop my
reviewed-by and tested-by tags from this patch when submitting v8?

For the record:

Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
 
> Changes since v6:
>  * Update commit message.
>  * Add Johan's R-b and T-b.
> 
> Changes since v5:
>  * Revert Set qcadev->initspeed since 6855 doesn't use it, don't touch.
>  * Convert get_fw_build_info to a switch statement
>  * Add poweroff handling
>  * Fix up line alignments
>  * Drop from microsoft extensions check since I don't actually know if we need
> 
> Changes since v4:
>  * Remove unused firmware check because we don't have mbn firmware.
>  * Set qcadev->init_speed if it hasn't been set.
> 
> Changes since v3:
>  * drop unused regulators
> 
> Changes since v2:
>  * drop unnecessary commit info
> 
> Changes since v1:
>  * None

Johan
