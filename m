Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E0B2A3551
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgKBUo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgKBUn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:43:57 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27358C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:43:57 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id g12so11795850pgm.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x3x/HrzVIOA7i+J/RozZZntmzD47m/EYqeEyRyC01Xs=;
        b=PpYGKjpm2dkbQwA2oJBfvPv3LX7xNDkqgkSRE8V/Ub6agcIJa/JtHooCq5zvNMyJZK
         uswkKAWyTTOiotGhH4LtLfPkJdRlaygahKjFZ8mtcubfgmE6ys7OzTJI9cuCpNfF71XT
         trsZV7xkfs8fWSFb6ldG8YElhk3WYSHheP6EcX9Yp3i6/Rh2Nhvy35qbW+PQoR1n94Lq
         2Hy3HlJ+Kx2TSuRVhxo5aW3N0yYdora9oEdg9ukBbyhbUkBEKECzGw940CC1feWawZiW
         Tghoso31auiGXjqdItt8y8xVPPSznbkgMZb5eJt2YZpSu+izbv1r4Q8nQSD4HXMAILRI
         rmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x3x/HrzVIOA7i+J/RozZZntmzD47m/EYqeEyRyC01Xs=;
        b=GyFMJ0dSrQdFKoLrsx2DaEnjOoYJeHZ7tXzARDj9vA3UAHwpIbC1f59FF6j5ROXE6D
         snIjru9nuEba3f+bSGhcRQPd0HoGWJvxC1Z1lJ0UUpslngxlIKCsrs+7d4W+A4mdIim3
         ZiEpCdwLq4u/TI0Oh7eOrtw0+k7IDs6qDcXGdOZAFZaC2+XMbXo06cxytKxV3gw8Tuyo
         VLPE0nGDlCMx3U7N7qWto1XkQU/J20doDdmAc9tTsNPnf/yTARhPNmj1y1tAqoxuAyGV
         IIeXskJkFplH4IVUMXjK+yJ38a/wvw7bDchQXqM5IBx4dJKtuVNoWBHhIYi1qxv37HC+
         c5lw==
X-Gm-Message-State: AOAM532NZwMQckCMmOkKEbjO5UOs3dHRzXbkPK1iGCAU8+UDk9xkSzFP
        yAvGL8TFAnvq53fpZQyPd60=
X-Google-Smtp-Source: ABdhPJyjkXdzFsxCAUiASrNQmAkqbmXddt0HP2SU4OiAGiOing59+u+3JlZNB9EvpVKS7Sx4UJi7Tg==
X-Received: by 2002:a05:6a00:783:b029:156:7d68:637c with SMTP id g3-20020a056a000783b02901567d68637cmr23152223pfu.18.1604349836644;
        Mon, 02 Nov 2020 12:43:56 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z12sm473975pfg.123.2020.11.02.12.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:43:55 -0800 (PST)
Subject: Re: [PATCH v3 net-next 01/12] net: dsa: implement a central TX
 reallocation procedure
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0dd6d247-b268-f051-074d-28573f0982f7@gmail.com>
Date:   Mon, 2 Nov 2020 12:43:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> At the moment, taggers are left with the task of ensuring that the skb
> headers are writable (which they aren't, if the frames were cloned for
> TX timestamping, for flooding by the bridge, etc), and that there is
> enough space in the skb data area for the DSA tag to be pushed.
> 
> Moreover, the life of tail taggers is even harder, because they need to
> ensure that short frames have enough padding, a problem that normal
> taggers don't have.
> 
> The principle of the DSA framework is that everything except for the
> most intimate hardware specifics (like in this case, the actual packing
> of the DSA tag bits) should be done inside the core, to avoid having
> code paths that are very rarely tested.
> 
> So provide a TX reallocation procedure that should cover the known needs
> of DSA today.
> 
> Note that this patch also gives the network stack a good hint about the
> headroom/tailroom it's going to need. Up till now it wasn't doing that.
> So the reallocation procedure should really be there only for the
> exceptional cases, and for cloned packets which need to be unshared.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers only
> Tested-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
