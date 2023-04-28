Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DA66F1D5D
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344368AbjD1R05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjD1R04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:26:56 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6814F2735
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 10:26:55 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b7096e2e4so226417b3a.2
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 10:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682702815; x=1685294815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xg1WuPLBMg3jXO+Jst3X7a4w6Jg4SJOwDNWJNJT8UuY=;
        b=tvZxLGvFDkA1LGBCHfYrWZAlRFVrytcT5pccJjWeflQ1z4beWp+a8NPOmMUuCSWiGH
         NBiCTehv5a9k6tpYoTfSCVVnVvWfDypIsqbQoqi39p52lZhfc8coHhGUUa/FVFoGGY8X
         2J9HlrKVFyTnn8DfRikWkbeSXnhUFXxLPhqmnSCAiNfRiw1vrR/+fQK5bCQSXxO6HHK/
         mF6tJHXnsyDTYXlTzj6F17kwcg+Di0nenEM7KWjMKD54GhZJzJ7cI3VPGV90OiJpPaEf
         lYPeebaYkZqlpK2q2uN1vr8uDrDunbzYJLSOinfwxQsf3oNOrN7A/OugFL5ArpkURETU
         UbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682702815; x=1685294815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xg1WuPLBMg3jXO+Jst3X7a4w6Jg4SJOwDNWJNJT8UuY=;
        b=PE2SZNsJrP+rjwStbaFBv74obsWZXhkrvs/ppc3Bw/+4CqKZDvBj0T84mc5CcOKQiR
         9WJoD6OMOHcrTlih9nxwD6vfg99Hdnuxx0rTjTwyRxSKkpBbyYSpjQb9GCNKC6UkE0he
         dAscQXjWh6qVH0HdbDn7at9A6siIdGIaV3MonWKGm0krjjhO3vusdcHHNu74KtGSmPGj
         aCFPAF5NE6tOp+wdGtqzbxAAJQsFJnnhxKAIR/Fbx5Ryu3rgHwRORBjI6YAFFBGzXPEC
         Os2+p5UjQtWai8f8deV/yJMnlDjnCiZkv7EEaqRzpNBbNXFoi0BJIvMt/xbhVqMBe4Ul
         uulA==
X-Gm-Message-State: AC+VfDxCS90JkYwWwO5uvT/u1OlQc2wdznme3y9De9zyaylyeJAwtkSx
        DqfL6lvlLmzXMLqAqaeO8cWNg8siE6j6LaZ0L2aKXA==
X-Google-Smtp-Source: ACHHUZ5mS4OMTuS3wI2TX/WZOmznlILapvBsuczutRxvL+ESYJly827UN/lszuhPLOnZ3TUcLjw1MQ==
X-Received: by 2002:a05:6a00:13a2:b0:640:da6d:bdc7 with SMTP id t34-20020a056a0013a200b00640da6dbdc7mr9179218pfg.33.1682702814921;
        Fri, 28 Apr 2023 10:26:54 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id n41-20020a056a000d6900b00637b0c719c5sm15381929pfv.201.2023.04.28.10.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 10:26:54 -0700 (PDT)
Date:   Fri, 28 Apr 2023 10:26:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     <kuba@kernel.org>, <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, Sudarsana Kalluru <skalluru@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 net] qed/qede: Fix scheduling while atomic
Message-ID: <20230428102651.01215795@hermes.local>
In-Reply-To: <20230428161337.8485-1-manishc@marvell.com>
References: <20230428161337.8485-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Apr 2023 09:13:37 -0700
Manish Chopra <manishc@marvell.com> wrote:

> -		usleep_range(1000, 2000);
> +
> +		if (is_atomic)
> +			udelay(QED_BAR_ACQUIRE_TIMEOUT_UDELAY);
> +		else
> +			usleep_range(QED_BAR_ACQUIRE_TIMEOUT_USLEEP,
> +				     QED_BAR_ACQUIRE_TIMEOUT_USLEEP * 2);
>  	}

This is a variant of the conditional locking which is an ugly design pattern.
It makes static checking tools break and
a source of more bugs.

Better to fix the infrastructure or caller to not spin, or have two different
functions.
