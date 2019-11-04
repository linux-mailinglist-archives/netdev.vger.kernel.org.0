Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459C6EE604
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 18:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbfKDRdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 12:33:21 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45826 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfKDRdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 12:33:21 -0500
Received: by mail-pf1-f196.google.com with SMTP id z4so6685030pfn.12;
        Mon, 04 Nov 2019 09:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BgXOsOEc+5cLDboF1XbHuAORCGwi89q1+rP30rGzYf8=;
        b=dY+QnrpmpYLIF9koIMAIn4yTToGuer/BFwzpa8/QwDMfmVRocfHymQtw2le14cEtyo
         12Zo6wmP3z9d6hr0HnJ4bOk1p5NT0D2n7tHz4mO3iql8DcZBYeYNaMG3BgitZhjr3jex
         YzITZqavRprNmBgm1qyvlvZqQmbomDWlIORE1v58zBf6mSC0MX4KS6/0vdEk2GVtOmOF
         JusllMgpcSx1oBF9F7PfwHWtdhGdX8W9yWs7EP+O75ZqzGO1661zCdTGx++Xtun2Ofiq
         8sOjaeo85yCEdezE2w8gktg+e/j7ToWmlT840gvKliFTorf3c1d98e2jqbSucuIp8sgT
         ayrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BgXOsOEc+5cLDboF1XbHuAORCGwi89q1+rP30rGzYf8=;
        b=L5Nxv2mikybhDxLcolKbL8Db4IVKACOKAQ11IIJSFhmzYpnr2ApFC2lMW/n8yRWM36
         NY1Z+2PLpYDyIYGvoZRy/Exl2Z40H2MrBDjfAzTcgH9yJbzHPn7ruVj35JMsZfcj25Y4
         MrcgjKJukbnmrrhhQiEcpwz/2JlaWWG0y7t7Zu4em9X7Iw+MxEAJaq0JC0wMICELUbBw
         rGMaieKDe5jiZAXq+3nBtL6NrJ03Ra/RS7xzgMqCJb4EHlM1IIrlaJhzN33aXJSRrpa6
         FQpX6B9lY7sesrpbq7x4fdbMAPCeq2ae7dcgzOM3DI0I05w7H7xGZjS8YhldmdcKngo2
         o13g==
X-Gm-Message-State: APjAAAVkohv6Wnz6JQrynG9u/LU+hViwkEjQ05cjWv7aoC8WbL9Hx/dn
        8ntoefSm1oRIGSNStOXZzCw=
X-Google-Smtp-Source: APXvYqxlK27EBxVTkfU6EdXr0TofKiBu6otugZJ2dTA77gcBk3V7uGmAZO65kzAphngDuRu77UgujQ==
X-Received: by 2002:a63:595:: with SMTP id 143mr31542800pgf.45.1572888800525;
        Mon, 04 Nov 2019 09:33:20 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 71sm7584170pfx.107.2019.11.04.09.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:33:19 -0800 (PST)
Subject: Re: Double free of struct sk_buff reported by SLAB_CONSISTENCY_CHECKS
 with init_on_free
To:     Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, clipos@ssi.gouv.fr
References: <20191104170303.GA50361@gandi.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <719eebd3-259d-8beb-025a-f2d17c632711@gmail.com>
Date:   Mon, 4 Nov 2019 09:33:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104170303.GA50361@gandi.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/19 9:03 AM, Thibaut Sautereau wrote:
> 
> We first encountered this issue under huge network traffic (system image
> download), and I was able to reproduce by simply sending a big packet
> with `ping -s 65507 <ip>`, which crashes the kernel every single time.
> 

Since you have a repro, could you start a bisection ?

Thanks !

