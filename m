Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DD3D02AC
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbfJHVPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:15:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34950 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730674AbfJHVPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:15:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id m15so330361qtq.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 14:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=sdCN/yjJsr9zZDKqIlU+6WzhYA4qUqwqrEXch5aCWjE=;
        b=K2c0KvPby17+QR8DZ7pdy3lmM5/Urw4j+sPsq/hj2V78OenJJXvIlSe1jfxvk3gRHR
         noXtkCA7RxKtaWMCCmkM4QcvzxrkPSFeabj36tHaGtbllc66prj7nxsVjblG3BupqfZF
         aK8cg6YiKJX20N3fNblN104m7oTpDglgKyuqtQLGkrPFnDZ09LmM0UF/hIpaURVaf/xh
         UpqcznkuiWfxYh27HcM+tkCCrh2t9QTVGKtMR1Eeu6IoFTqz/U5Op/CNeSnRVqOdTaGu
         2cNY38JukWFfk25lawFXiZSWdRqCYobRgnW3bFx0wjD0nJUsJslWBvVKnxsnZhYOW/pa
         4Jmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=sdCN/yjJsr9zZDKqIlU+6WzhYA4qUqwqrEXch5aCWjE=;
        b=RbUr8o25jycS+nqbHgSUTQuONF9qaadKaOaDAx+P4Zujdeso/hWgVo5Tl42+40iT+A
         qEb0FRPXB15AbqRsb5btJzJJ4v/wwClx8Hw20A3Je35n4xRZqKhorwctK5hTwrRYDElG
         6UlqLkW/DPBbWX5VU5Zf0607kqJQLcfOuz6cWqdHOJ9iXJaS+egAbD8epQGfb+Vzu9HL
         f+77ni13dBY77gzaVlwNpigK05BcfSN6WTRH3YuxNSjkYCbZL+94zWL9dddaMy5QvuhJ
         gYICpWoZPhA8kM4BnOapzjzS35S4fI9HmzD/0KnSJRgYeAq9038isXCK08V6SA9xCOZI
         hwtA==
X-Gm-Message-State: APjAAAWAToIl8XvtCONHPy0mwaQYa4XteSDEmIlTlmG8Amj9N+FRdjYm
        r9UAq4P6OezcZYxld2rjiaJnMKSAJoo=
X-Google-Smtp-Source: APXvYqwzGWVRag8vllJXzmus92pC8hTfjptv5/m65u/YcjZ0fT9X6h/b1ySXYHqJmn+OUC+VP+4Y0A==
X-Received: by 2002:a0c:fca9:: with SMTP id h9mr243713qvq.14.1570569330216;
        Tue, 08 Oct 2019 14:15:30 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x19sm9401544qkf.26.2019.10.08.14.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 14:15:29 -0700 (PDT)
Date:   Tue, 8 Oct 2019 14:15:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] llc: fix sk_buff refcounting
Message-ID: <20191008141518.145af65c@cakuba.netronome.com>
In-Reply-To: <20191006212427.427682-1-ebiggers@kernel.org>
References: <20191006212427.427682-1-ebiggers@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  6 Oct 2019 14:24:23 -0700, Eric Biggers wrote:
> Hello,
> 
> Patches 1-2 fix the memory leaks that syzbot has reported in net/llc:
> 
> 	memory leak in llc_ui_create (2)
> 	memory leak in llc_ui_sendmsg
> 	memory leak in llc_conn_ac_send_sabme_cmd_p_set_x
> 
> Patches 3-4 fix related bugs that I noticed while reading this code.
> 
> Note: I've tested that this fixes the syzbot bugs, but otherwise I don't
> know of any way to test this code.

Applied, thanks Eric.
