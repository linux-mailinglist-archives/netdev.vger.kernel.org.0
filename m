Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D3E666E80
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbjALJmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 04:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239842AbjALJlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:41:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0834C719;
        Thu, 12 Jan 2023 01:40:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 214CB61F8B;
        Thu, 12 Jan 2023 09:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D73C433EF;
        Thu, 12 Jan 2023 09:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673516430;
        bh=SCtzrnBNYnhocbWJE9NRFOmFwapY2gNywzGDKeHtHEc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qHZbYqFjTpM/FZ6AmwD+/w8oBegPrJpSdNscwGTK3e+2/+kTqP/6+qHgemqB7Y0Gq
         CNDTpp7dN2MnTP+LLvotqldVq0jvzUm6PSuHqp6Spgv38hq00m2ZXBVrZgTr8utPfe
         NM7tjjJeupSXzWMm/Kc3UXL1zfuHTxwBOQq7WqhudZkosTRvWkEuC+l+A7Sz67iLeJ
         PDrr4Qy8YGYrObtHq48dCulgFtWkyKMd6hg9SLCgvmQWcLHBpn1FpLEjkHg4Cs0d7G
         vDXW550ll/hUyAyQc1mufcSGwKSEzDqxNUBNRvjtkZCv1g/avQ/IOgEezfBC1hwzZx
         FKpVpZ15lS5Yg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Robert Marko <robimarko@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, elder@linaro.org,
        hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        quic_qianyu@quicinc.com, bbhatt@codeaurora.org,
        mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ansuelsmth@gmail.com
Subject: Re: [PATCH 2/2] wifi: ath11k: use unique QRTR instance ID
References: <20221105194943.826847-1-robimarko@gmail.com>
        <20221105194943.826847-2-robimarko@gmail.com>
        <20221107174727.GA7535@thinkpad> <87cz9xcqbd.fsf@kernel.org>
        <877czn8c2n.fsf@kernel.org>
        <CA+HBbNFCFtJwzN=6SCsWnDmAjPkmxE4guH1RrLc+-HByLcVVXA@mail.gmail.com>
        <87k02jzgkz.fsf@kernel.org>
        <CA+HBbNHi0zTeV0DRmwLjZu+XzUQEZQNnSpBMeQeUPiBu3v-2BQ@mail.gmail.com>
        <87358hyp3x.fsf@kernel.org>
        <CA+HBbNGdOrOiCxhSouZ6uRPRnZmsBSAL+wWpLkczMK9cO8Mczg@mail.gmail.com>
Date:   Thu, 12 Jan 2023 11:40:22 +0200
In-Reply-To: <CA+HBbNGdOrOiCxhSouZ6uRPRnZmsBSAL+wWpLkczMK9cO8Mczg@mail.gmail.com>
        (Robert Marko's message of "Wed, 11 Jan 2023 18:10:38 +0100")
Message-ID: <877cxsdrax.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Marko <robert.marko@sartura.hr> writes:

> On Wed, Jan 11, 2023 at 6:10 PM Kalle Valo <kvalo@kernel.org> wrote:
>>
>> Robert Marko <robert.marko@sartura.hr> writes:
>>
>> >> Really sorry, I just didn't manage to get this finalised due to other
>> >> stuff and now I'm leaving for a two week vacation :(
>> >
>> > Any news regarding this, I have a PR for ipq807x support in OpenWrt
>> > and the current workaround for supporting AHB + PCI or multiple PCI
>> > cards is breaking cards like QCA6390 which are obviously really
>> > popular.
>>
>> Sorry, came back only on Monday and trying to catch up slowly. But I
>> submitted the RFC now:
>>
>> https://patchwork.kernel.org/project/linux-wireless/patch/20230111170033.32454-1-kvalo@kernel.org/
>
> Great, thanks for that.
>
> Does it depend on firmware-2 being available?

The final solution for the users will require firmware-2.bin. But for a
quick test you can omit the feature bit test by replacing
"test_bit(ATH11K_FW_FEATURE_MULTI_QRTR_ID, ab->fw.fw_features)" with
"true". Just make sure that the firmware release you are using supports
this feature, I believe only recent QCN9074 releases do that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
