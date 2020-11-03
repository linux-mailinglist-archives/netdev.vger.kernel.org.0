Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5623F2A4D7C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgKCRv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgKCRv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:51:26 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5A9C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:51:26 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id o21so18418535ejb.3
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2xZ3OSqt3OKJmFUnSZxKOfcuIvpUVoePdMD+kWkqBMQ=;
        b=nyWX9Q0fe0ppZ2lch9iosChwuP0lCeKV+Gr0tmaAD2lfuTPCyRronkOnYRdM3rq47U
         gbvP9N0AQ8H3DgSDU4jYp2+cD3+hGSLQMnbiYCCL5HHA5yfuao0Fg0nDydKc2phHmsRX
         Uwo+fEPrU2Nh73d6CqZySX/hH2oZ/ee17hwt1TQp5fyk1PmX9N6Mm1Oq7RrnNVoVH2KU
         3feKjxgEydr1TwbOnnqdUhAQertRJX4WzX4rhrZXBlKalvDHD9Hofs7p+1kMzZJSJk7P
         fFM0N4N3DNjGRLZa3BodwGEpTEAKZF7YDFHn9SSOyBVOluu1sJR50wh4SxQyGoHMwVY4
         2/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2xZ3OSqt3OKJmFUnSZxKOfcuIvpUVoePdMD+kWkqBMQ=;
        b=sT4x7jT3hNkpohcMPf3Q1/ArdS4t6uALa0fwyckC3KTwGSY2LJB7W/dslWcrYB6he7
         eT0GsgO55FOE6QBZX/stkBDnQLzSfn/4CXeYPmZhvUZImgFNmmy1lKX1J07OCVeZFQD7
         62/u9STe8qX4ou0FM7Uy5ZVVlR83fov9f5e3nIwXNoHKxmQMk5bSJLxKYuYEaO2d6WXb
         CCcqyLF4T6H5yw9xMf8ssTuPtOJcULGFlM8wezJ0d1GJ5ZweRpd5Tfn9cXMb28aJN9FH
         r0ccaK1GFRhxXfJzmYDewsIHNCjqtJvQxO4wAwAi4/CUnZkrrN2m6sEBiNB1+pcrCglV
         G3cw==
X-Gm-Message-State: AOAM533crFHRGye40agHv+Ly8pTwRyuEPNQjzFbGxwySEq8xT3bZ+vvQ
        sU90mHkjq6jQlZ1EUCufoqg=
X-Google-Smtp-Source: ABdhPJwPh7b3VRE3UmWl2/CNg5TowX7/3D9DUmjmBHCQQpBllz68ztFHK44Z39u2draz4oYXdvxrzw==
X-Received: by 2002:a17:906:5052:: with SMTP id e18mr20199129ejk.530.1604425885260;
        Tue, 03 Nov 2020 09:51:25 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id bx24sm11380220ejb.51.2020.11.03.09.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:51:24 -0800 (PST)
Date:   Tue, 3 Nov 2020 19:51:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103175123.a5xq2ujd2kovtrnp@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103173007.23ttgm3rpmbletee@skbuf>
 <20201103093655.65851a21@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103093655.65851a21@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 09:36:55AM -0800, Jakub Kicinski wrote:
> IIRC we did this because too many drivers used dev_kfree_skb
> incorrectly and made the dropwatch output very noisy.

Nice, so that's why the drop monitor never complains with my misplaced
dev_kfree_skb_any calls...
