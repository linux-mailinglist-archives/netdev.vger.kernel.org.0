Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463EB783B7
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 05:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfG2Dnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 23:43:50 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:35025 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfG2Dnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 23:43:50 -0400
Received: by mail-pg1-f173.google.com with SMTP id s1so21189376pgr.2;
        Sun, 28 Jul 2019 20:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=spXdUxCtUWc6Ma6GamSGGP+kblTO8jCHKcnziir+xwI=;
        b=LF54msqUrTQ7In+GCGa7hpXWB4JwdMUtCEeLkeQnxQ6al6Zn/OZf77ZMA7FU8R4buS
         monkN3tK+oRGltp9lty9LTmyp/924vYZTTZI8iwl7FwNvO/9jrkuZb1t1V4HSpkm3Qqe
         ZrN27omLaXYwjU/43uBnwoOHDBuIY/qZaxtoe97tFLJRELsE6+DX/zahGpzHb6qLMvnM
         4uURCx/oaMQBVfR1LB+jabtJfCzhxHOICsDaaJzaThUSEEMIx42kND93NW/XGGJkJIZw
         rkAt6+Y3ax3zx0r0Ed1Lt5kOjWxe/ERPgV/cMPvZPxDvNpYHB7VlgtV2kUFK8KXktsOK
         BM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=spXdUxCtUWc6Ma6GamSGGP+kblTO8jCHKcnziir+xwI=;
        b=KgwYlm+8TyXkx/t1FakPCF4TNexxwVPXfehdmob3Xr8rGPBzKUzXeCUO6LVb9xGQcA
         Umhf9HAjCInzKef63ZChjOskCJ/aHpx5OKPRlU2uN8gUFfHph/3bLQmbjUqmvY5i5P7Y
         lGGhCmvRlDm7aseI9dqSDaKxjRC5EZhXqwQ7yQMrN60aNztgSvQK05f18r/xqTRG8f48
         +QqMaK6ip11DxlrdjofAOb6M2Run6lsKN7Wx1X9whf9mdhCGTNsGyi/BtqBgx1sleDkM
         L7LC1RJKHxudBMc8nuYT4mwRLTiWTOq9pGR7BQCtRZHKBOUvDh2RiNP1r26wkl9HP7jP
         QTFQ==
X-Gm-Message-State: APjAAAXPGFF37oz5e1rIzxcH2xjQXEiYi+gbVtEkEG7c1zF4brBk4VWp
        hmMeQ+mfuDqgihpb0AJMX5JoENMV
X-Google-Smtp-Source: APXvYqwuYF1K452KRahE63BkfFu99gPYCsas9dC3SN9WSj1j0pv4JqnTZ7IlwDETqARFUfaAovUtZA==
X-Received: by 2002:a62:38c6:: with SMTP id f189mr34469301pfa.157.1564371829529;
        Sun, 28 Jul 2019 20:43:49 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id a12sm100261192pje.3.2019.07.28.20.43.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 20:43:49 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: xfrm: possible null-pointer dereferences in xfrm_policy()
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <464bb93d-75b2-c21b-ee32-25a10ff61622@gmail.com>
Date:   Mon, 29 Jul 2019 11:43:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In xfrm_policy(), the while loop on lines 3802-3830 ends when dst->xfrm 
is NULL.
Then, dst->xfrm is used on line 3840:
     xfrm_state_mtu(dst->xfrm, mtu);
         if (x->km.state != XFRM_STATE_VALID...)
         aead = x->data;

Thus, possible null-pointer dereferences may occur.

These bugs are found by a static analysis tool STCheck written by us.

I do not know how to correctly fix these bugs, so I only report them.


Best wishes,
Jia-Ju Bai

