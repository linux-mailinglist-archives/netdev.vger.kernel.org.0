Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068AF105DEF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 02:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKVBDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 20:03:54 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34091 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfKVBDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 20:03:48 -0500
Received: by mail-lj1-f196.google.com with SMTP id 139so5401854ljf.1
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 17:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=m913jDXRVfEU7lrY83rHrp6DULNdfWEGAoaZqXDkLTA=;
        b=pdPSpxfBL1Ad/3JxV2mSmO4/6BOLjdGP/pkx3d6hs6QjMYWgNGmqybdAf8cVPb89MZ
         7iy9H6Bwou+6jSwmM1TkH0C9Mb3il/QOlSAbnUqSfnXx9R4E3u4GoTFqXkAYmUgbtWG/
         tldohmrkjSlw5hFcoW0L9cq3GjjCoh3i9UnrYfAl89Haytv6HBQTb73zmL5Nk1fmEdxY
         H31lfYB9925iXHbcDYjLF1RNJTiR5EYdDBnU0AAQfTpg0fiXE0TuYDdFNdeBB0waW0GY
         jKh67f3p7oxgyRw2uOMO5swxmrTiGZHbsFXZ73I5CTvbVBFrzxOtnpwyrzVggFornKH6
         tDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=m913jDXRVfEU7lrY83rHrp6DULNdfWEGAoaZqXDkLTA=;
        b=D/mC4MkDcMxEMPpQ+OYqb3gEpxqNvGzPuZs7heNRay17C3LkHR18r0p1+7+b1/7/Yi
         3l+h9/QGZtx34Zw752bmmX6sH4WubvSIhegSjwqWiJ9aYtLR3kL/88QPolHkzt0BanjM
         JosCagcdPnR0fNWt7wVb/aaL+sDVcuvZTEdWGYTmMMvKlBPsTtV2YLO4ZlnuqRXEM1rr
         Xk83xvH+Rs73LZfBqIPZdgpzYRL+v7kwnuIbtqZUOPeuPOXpv8KLRvWccTxuO8xKkRru
         S0W8HIQ0U9q3sVF3cZapEgSa+2lCxquCs31F4qK501drYbgbS+MDM1F6v+dr65v8/wiT
         t3gg==
X-Gm-Message-State: APjAAAXXXYoKFFIf34faBb364VLufUBKbEURVXLRnYSLfgaVrCrU8N+l
        WZDhjYxsBNT4bL9UNa6KqTB9tA==
X-Google-Smtp-Source: APXvYqwnfSXY9PpKVzQQhCKshLxwXTVie+X/fnKl31b0ZdToCRb9i101bmYL66lYSpv5fqV8f+CPAQ==
X-Received: by 2002:a2e:575c:: with SMTP id r28mr9849257ljd.245.1574384626222;
        Thu, 21 Nov 2019 17:03:46 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s27sm2253515lfc.31.2019.11.21.17.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 17:03:45 -0800 (PST)
Date:   Thu, 21 Nov 2019 17:03:35 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net,v2 1/2] hv_netvsc: Fix offset usage in
 netvsc_send_table()
Message-ID: <20191121170335.2f73792d@cakuba.netronome.com>
In-Reply-To: <MN2PR21MB13750EBD53CFDFCBA36CF1D8CA490@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
        <1574372021-29439-2-git-send-email-haiyangz@microsoft.com>
        <20191121150445.47fc3358@cakuba.netronome.com>
        <MN2PR21MB13750EBD53CFDFCBA36CF1D8CA490@MN2PR21MB1375.namprd21.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 00:54:20 +0000, Haiyang Zhang wrote:
> > >
> > > -	tab = (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
> > > -		      nvmsg->msg.v5_msg.send_table.offset);
> > > +	if (offset > msglen - count * sizeof(u32)) {  
> > 
> > Can't this underflow now? What if msglen is small?  
> msglen came from the vmbus container message. We trust it to be big
> enough for the data region.

Ok, it looked like it was read from some descriptor which could
potentially be controlled by "the other side" but I trust your
judgement :)

Both patches LGTM, then.
