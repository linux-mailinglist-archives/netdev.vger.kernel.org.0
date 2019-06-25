Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EECC55C9B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfFYXrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:47:22 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]:42016 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFYXrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:47:22 -0400
Received: by mail-qk1-f177.google.com with SMTP id b18so168812qkc.9
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HXIN3AK6tVdQORJggp2c7cMamk7lRUuRm0beM4tlZbE=;
        b=ArzGp6HZc2aR2YxslCfWgTfi/ppOKx2pkPg9mQhnhH411HMGpzID0/UergeOajGKNp
         PUqa96bFmTRPisJn66sDf1Pk0AajeMZGaFTYrM0bB2A0yD6KInVK/4BS0VMNNuKaAoSP
         +PJ4sSzxdMpmuPvt+YbgPsC1UxyXrGraae6VU33uQlzV8XmJLrcUgf7jEqfASlKRxCoI
         yqf2HMlYseyEdI5f1lAdGzHFBnTgTTbzKdzPzpUsvEUzpAE1SRf5Z6ggDFMKpN0d0Mqp
         ve0nw5K3zq0raf9Jw9Th5mgT4wPjyT/LSl6lIaE06hLhSMls1QGdftTLsRaZu/LZRuBU
         ZP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HXIN3AK6tVdQORJggp2c7cMamk7lRUuRm0beM4tlZbE=;
        b=DK+bkkJ1u6pgrGcMPeNFOp8QrPQLneKNf6suI9hf+hcSKbvNsiXKWfBUx/kqh0HKc1
         2ZIMTLQwQc1fsy6DwB4H5nMBnHVWJOG8+msYy9cx8+dMejJsRxbGmIB+bfrYcuRapBom
         NoWQ1Yml2nL70oiJDYOXDvrIXUuC5BIqnROmZBt+zShMmvv+XVWE68GI9VphL6Yv/b2F
         s6I7FDhgHZyXRf6iVWbrWo7xvuxD2j5K1SWRjx3Dj7JZZPP3mkSHOZbqkv+LQuveopJc
         XsvICAGZsCNZdL3j51PkRcO7AKcgKwH4MzA+nNJQnzKmO+LFFxX2B7nY2GOZFdABCvP/
         asMA==
X-Gm-Message-State: APjAAAWuNXDpW0xnlk2U4CPhVCLNNPAPYmqD9chK9Cc2WFgy5dD3F31R
        tD0j4CoqkiWykPmxqsbcrdVShLP2C0E=
X-Google-Smtp-Source: APXvYqxNl+t/obEZeu00T/1wE6f6v9uG2577r+hqx/C5hrka32EQRtceKYyi+ZKW6Kls7pm3bpkYKA==
X-Received: by 2002:a37:6652:: with SMTP id a79mr1328334qkc.60.1561506441428;
        Tue, 25 Jun 2019 16:47:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n93sm8434490qte.1.2019.06.25.16.47.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 16:47:21 -0700 (PDT)
Date:   Tue, 25 Jun 2019 16:47:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 12/18] ionic: Add async link status check and
 basic stats
Message-ID: <20190625164713.00ecc9aa@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-13-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-13-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:18 -0700, Shannon Nelson wrote:
> +	/* filter out the no-change cases */
> +	if ((link_up && netif_carrier_ok(netdev)) ||
> +	    (!link_up && !netif_carrier_ok(netdev)))

nit: these are both bools, you can compare them:

	if (link_up == netif_carrier_ok(netdev))

> +		return;
