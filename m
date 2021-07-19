Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456DB3CCDED
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 08:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhGSGdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 02:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhGSGdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 02:33:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485C9C061762;
        Sun, 18 Jul 2021 23:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=LY5CK1r0/hjsqY17xf0eUdo8D9KcHjidZGqfXP+fN/Y=;
        t=1626676233; x=1627885833; b=K6SH53/9xDU+0DkCI4/OcTZ/rHSSe7cqFOwfd2q+2cqsRVA
        vZpHgN5AMo3Knlp2fhqU52RISVdFMwURfcpzmQkycypuHGVUHrJ91M3Mm7VBWnlVBKjWxOHDdSFqS
        P6fJUPA/bC2TVdoPG1oWDFPg0a7NWKEql73yMKaAsAdMYfiGBlxX7h3lWRum0QyAAwdkUAYx0w3RE
        KbbO6vyUPTpIsNcd4hmbmRbxju+eRemuBJlUVtp0BQlnZ7pCgNIKgb//SLbv4ZiKO0zSt9pGlXocL
        YRTnu4tEFZOXGOhc//zfeSINDHTo5EiMKaO3o7YaQJ6P+l91EzM9wl2avi8NEWXQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m5MnM-004Fmu-7W; Mon, 19 Jul 2021 08:30:28 +0200
Message-ID: <5c43c41de4bdfd2412d5f2feadffc309243ed134.camel@sipsolutions.net>
Subject: Re: [PATCH RFC v1 1/7] mac80211: Add stations iterator where the
 iterator function may sleep
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Date:   Mon, 19 Jul 2021 08:30:26 +0200
In-Reply-To: <20210717204057.67495-2-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
         <20210717204057.67495-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> +/**
> + * ieee80211_iterate_stations_atomic - iterate stations

Copy/paste issue, as PK pointed out too.

> + *
> + * This function iterates over all stations associated with a given
> + * hardware that are currently uploaded to the driver and calls the callback
> + * function for them.
> + * This function allows the iterator function to sleep, when the iterator
> + * function is atomic @ieee80211_iterate_stations_atomic can be used.
> 

I have no real objections to this, but I think you should carefully
document something like "the driver must not call this with a lock held
that it can also take in response to callbacks from mac80211, and it
must not call this within callbacks made by mac80211" or something like
that, because both of those things are going to cause deadlocks.

johannes

