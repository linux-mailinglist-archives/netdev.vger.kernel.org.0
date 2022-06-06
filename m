Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AC553ECD1
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiFFROC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 13:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiFFRNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 13:13:46 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AFD366B3
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 10:04:16 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u18so12604476plb.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 10:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=CyWF09OzZxcB2K1Aed72uymGrOLckmk71H2nyGVg4zY=;
        b=cCFQHaLvQAH6GknCpb5d6lVa9a1FTUBLqcL61p2t2cdzUCV91fyyLbtB6QVoeW0eQt
         RLUiGofDTsoQUzdlKpPLKNk1HQ6cDgDYcd9lmhZ3VSkm8+4nxGtqn64EpWmLqEPXFeqO
         BYvSPDm9iQIrAzMyZQmIPjhUkJs3ke64Z5zeiBUx4RZojHaMZCmlmgd+i9tyRa16a7BY
         gFwq7lBYfPOevt3UzhHQsv6Nvk1g3hwL4SWzg5Va5LR/AJ9mMl/EPBTBfTEsbhQWTgAn
         II7C2MEBmFRut/8mwtTV81lVlGiTL+O/IUjzKMVtigqTBQRj1NxnRLvpN8ASVrcFObpW
         M1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CyWF09OzZxcB2K1Aed72uymGrOLckmk71H2nyGVg4zY=;
        b=sRZ321aidULwTOTXAw3QER+7iwRi1L2I8dz9zO7JSnRpAggYb/L19n+gglQq64z2pE
         XBVre8F4a9NCYWfjE4jeGusI2Ww3/YqHWoreYtPaI2u7F0l+xStkTH6CQ25zfrh4vLM0
         2Mxm7VWcM9OUSpmYaCnJ6oOu7WC/ppmtiDDKPFNlvmliU4xvWljaDK/RImIWUxYHlLev
         +GAokfPoj37DmOmGmeMNoG3vCQ4QuKQLh3XKPhbacuULj2kGaolrOkFly7Hi6RoIj7be
         dfknTaTqdS5CMVlTaG9jP1kp+bakAjHVAT5V4EG9zzGIKxZoKkhCEVROmp2IvizyvO5e
         vEOw==
X-Gm-Message-State: AOAM530rleT6dNrjnnSHIxCtlAkyi/AWarN6OOAGYQgc61/cN2Ewod6Y
        JdGXGDZFfLvmZ2D2IA7WuW+u3znwSD8=
X-Google-Smtp-Source: ABdhPJwRCJqhZwSHjYOtH7REGuF7ymQvvaAZeiAt4vre6Erb+On6VF4BN3QVgU708/xEZH58fZ6F3g==
X-Received: by 2002:a17:90b:3c6:b0:1e2:e9fc:4e79 with SMTP id go6-20020a17090b03c600b001e2e9fc4e79mr47490529pjb.192.1654535056293;
        Mon, 06 Jun 2022 10:04:16 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.37.52])
        by smtp.googlemail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm13408910pjb.0.2022.06.06.10.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 10:04:15 -0700 (PDT)
Message-ID: <83e2fd08cabc0227d105c80d8e0538f546754cc7.camel@gmail.com>
Subject: Re: [PATCH v4] igb: Assign random MAC address instead of fail in
 case of invalid one
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     =?UTF-8?Q?=E6=A2=81=E7=A4=BC=E5=AD=A6?= <lianglixuehao@126.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, lianglixue@greatwall.com.cn
Date:   Mon, 06 Jun 2022 10:04:13 -0700
In-Reply-To: <0362CDDC-AE9B-448C-BE7C-D563B12D5A61@126.com>
References: <20220601150428.33945-1-lianglixuehao@126.com>
         <f16ef33a4b12cebae2e2300a509014cd5de4a0d2.camel@gmail.com>
         <0362CDDC-AE9B-448C-BE7C-D563B12D5A61@126.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-06 at 22:35 +0800, 梁礼学 wrote:
> Hi,
> thank you very much for your suggestion.
> 
> As you said, the way to cause ‘Invalid MAC address’ is not only through igb_set_eeprom,
> but also some pre-production or uninitialized boards.
> 
> But if set by module parameters, especially in the case of CONFIG_IGB=y,
> The situation may be more troublesome, because for most users, if the system does not properly load and generate 
> the network card device, they can only ask the host supplier for help.But,

A module parameter can be passed as a part of the kernel command line
in the case of CONFIG_IGB=y. So it is still something that can be dealt
with via module parameters.

> (1) If the invalid mac address is caused by igb_set_eeprom, it is relatively more convenient for most operations engineers 
> to change the invalid mac address to the mac address they think should be valid by ethtool, which may still be Invalid.
> At this time,assigned random MAC address which is valid by the driver enables the network card driver to continue to complete the loading.
> As for what you mentioned, in this case if the user does not notice that the driver had used a random mac address,
> it may lead to other problems.but the fact is that if the user deliberately sets a customized mac address, 
> the user should pay attention to whether the mac address is successfully changed, and also pay attention to the 
> expected result after changing the mac address.When users find that the custom mac address cannot 
> be successfully changed to the customized one, they can continue debugging, which is easier than looking for 
> the host supplier’s support from the very first time of “Invalid MAC address”.

The problem is, having a random MAC address automatically assigned
makes it less likely to detect issues caused by (1). What I have seen
in the past is people program EEPROMs and overwrite things like a MAC
address to all 0s. This causes an obvious problem with the current
driver. If it is changed to just default to using a random MAC address
when this occurs the issue can be easily overlooked and will likely
lead to more difficulty in trying to maintain the device as it becomes
harder to identify if there may be EEPROM issues.

> (2) If the invalid mac address is caused during pre-production or initialization of the board, it is even more necessary 
> to use a random mac address to complete the loading of the network card, because the user only cares about whether 
> the network card is loaded, not what the valid MAC address is.

This isn't necessarily true. What I was getting at is that in the pre-
production case there may not be an EEPROM even loaded and as one of
the initial steps it will be necessary to put one together for the
device.

The user could either make the module parameter permenant and have it
used for every boot, or they might just have to set it once in order to
load a valid EEPROM image on the system.

> And I also noticed that ixgbvef_sw_init also uses a random valid mac address to continue loading the driver when 
> the address is invalid. In addition, network card drivers such as marvell, broadcom, realtek, etc., when an invalid 
> MAC address is detected, it also does not directly exit the driver loading, but uses a random valid MAC address.

The VF drivers assign a random MAC address due to more historic reasons
than anything else. In addition generally the use of the random MAC
address is more-or-less frowned upon. There is logic in ixgbevf that
will cause the PF to reject the VF MAC address and overwrite the MAC
address from the PF side.

As far as the other drivers they have their reasons. In many cases I
suspect the driver is intended for an embedded environment where the
user might not be able to reach the device if the NIC doesn't come up.

The igb driver is meant to typically be used in a desktop environment.
Catching a malformed MAC address is important as a part of that as it
is one of the health checks for the device. That is why I am open to
supporting it by default, but only if it is via a module parameter to
specify the behavior. Otherwise we are changing a key piece of driver
behavior and will be potentially masking EEPROM issues.

