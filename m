Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D00A9115AAB
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 02:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfLGBty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 20:49:54 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46858 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfLGBty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 20:49:54 -0500
Received: by mail-pf1-f194.google.com with SMTP id y14so4244129pfm.13
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 17:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UcfzSMiZCigKmCFWt0Cef+VTb2tSXYkjOImyoVgyFqE=;
        b=LkxAqheH/EycG3F9sGD4UFYPV0YkMH/p/BL46gZQNgiZcJQLNzM+X6hVgNk8T+if3f
         FztxHoqQYOiRLmf8G7mc2svEgPsfOHzX/yAhVRaDjdfa2av1kIfX+htjdR/PaytJSXuK
         90hg7juetHVt1J4sdof+c/OeJP7mDWxLpoJduB/+ihbKt9a0lROaJZ4xklBtxFM3UHuT
         CCXm4N66jo7KU2d6d9ogFrkU7Obn1WwtxWjVIB4KLWcLMZQsd+PCuMoMntwFs1+ChYKu
         ueHNZ8MIRs+fC2JYK4wpJTyOyXLC9dJ4MCNvr/wN8bckDpFRkxXEAhrQZ+qfL+M5x+tx
         K4Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UcfzSMiZCigKmCFWt0Cef+VTb2tSXYkjOImyoVgyFqE=;
        b=XLq+zZQpLuS72Akp0Oj3uDiOnpVQJziNm8e0tBY7lLke19L5s7lao4DU9s8KyBRHuM
         sKhgZxY0BOTVcrYlRMqBJsCpwVNZ/OWmlOQji1FEeHZAAKA66f5eo9Bg2IWTEPi+g2Sr
         s9fxp4x/e92GgamWkuPjPa0sQfO15zjr/zdZ9KJS+f4vuR7cEfJXrm1EeSN5ESeLDX8Y
         wa/P2m7KEoKMVXusUKp9stf6IiZcY1Wvx8wn43vsSELeigh6/nyUe/8WF7631BzuiwH+
         g0v6OyIvbEoYGGQhkEg0W89kblGfeLghkgC7xnpnlAXzLU+dVe385Rr+uNEjEb7Gms6N
         U0+g==
X-Gm-Message-State: APjAAAVRuSfLKFMKif3e5jgf+pnXVK/xPgnk/jr6W+KvfJin6H21T1mi
        a+P8zYqqd91o/uuzUh9Y6lnCFbLQ
X-Google-Smtp-Source: APXvYqx/RThS7Kj0TcTNSbb8psscZtBk0tfbEHL6TdyIHaTXY62bQ1rlGSBwO1IgwGSmul68m2POMQ==
X-Received: by 2002:a63:7d8:: with SMTP id 207mr6939215pgh.154.1575683393673;
        Fri, 06 Dec 2019 17:49:53 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id m34sm16241002pgb.26.2019.12.06.17.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 17:49:52 -0800 (PST)
Subject: Re: [PATCH net v4 1/3] tcp: fix rejected syncookies due to stale
 timestamps
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1575631229.git.gnault@redhat.com>
 <b1e80e43ba300a37ac5ea70088769fbe8ac5bf01.1575631229.git.gnault@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3eaa158d-32e6-d541-d0fc-d1b79738f84f@gmail.com>
Date:   Fri, 6 Dec 2019 17:49:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b1e80e43ba300a37ac5ea70088769fbe8ac5bf01.1575631229.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/19 3:38 AM, Guillaume Nault wrote:
> If no synflood happens for a long enough period of time, then the
> synflood timestamp isn't refreshed and jiffies can advance so much
> that time_after32() can't accurately compare them any more.
...
> 
> Fixes: cca9bab1b72c ("tcp: use monotonic timestamps for PAWS")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>

