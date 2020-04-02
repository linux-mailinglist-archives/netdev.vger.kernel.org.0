Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1641919CCC0
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 00:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389729AbgDBWVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 18:21:04 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38495 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgDBWVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 18:21:04 -0400
Received: by mail-pj1-f67.google.com with SMTP id m15so2070565pje.3;
        Thu, 02 Apr 2020 15:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=KpQBdYnZ3QRBd3mmVWoDmswwLkLLj3nrwulMo7pb1IE=;
        b=HFiRXd90SPWjAQeiyUYEsotmCJ5EcVEbXwLpgtCWqAoLeN+jX0ovkTIORTd6h9+yDt
         XSpJGl3tYAGDxqCwtR8fp2FqIq4XvVWZ9p/YdqY1hTM5/sXnXKZHtr0t4bjxycZjx7fK
         XUf8osJceEOAAE7GJqFq4zT2Tof3FLYM8w5ML76lbmDKkyjULalwPAeeQMQlsWvhFErJ
         L7T5NFvcrR2U46FsCfl+ZlIehkzjXNSBGg/P7Tc5tfv7NL/M79xNXQ3Vk6ybgzlw+z9J
         RROm895nZoZzyspfMfCnzG0MHsMof8ccQiIzjLFcK18+91qe12KhwOirMS9VNGluq3Sz
         nK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=KpQBdYnZ3QRBd3mmVWoDmswwLkLLj3nrwulMo7pb1IE=;
        b=ernCDzL5ch8NC0JOPbERdZvf9ysqGykB3Z+XMG1LNfZjNujNf5yJtWFnPTDKM0QY7Z
         dAQt2pIR3p2Hg0HDjWItH/KYeAui4aoXWfTtDhcEfUEN6S+ilOB7FNeAXPnjFgAZiZqG
         kPo4sJh57leByse+ff+pDwlo1mXwvXycZwBBuvgdoQC9y1FEKbXcTpQyrIL34lhTQ1rj
         hY29Xtl+3vp1082pXkge9clz4Q/kByBviR9o5d/96tvmAmIXw0YAZHn0i9PIj2aMUEJw
         pNEjzLt+grNf0hMv1WmRjnjrz0/P0TEw/qQ06fNVXN/n4b7y61OWX/2XZkCtdx6XErqZ
         6/UA==
X-Gm-Message-State: AGi0Pua2Kp1L5u8tfgb/5CZwwT7tkOffdIZBqaqK6gsoa9aSF4HxZevv
        y2zLq6s/ATiW3JkYAful5z4=
X-Google-Smtp-Source: APiQypKQrvHmr5s8XwIXnQ2CNa+PS+1HFbUu52qbOrotfsfNGCwy3ERqKL+397db28WwQ7A8gcewgQ==
X-Received: by 2002:a17:90a:a484:: with SMTP id z4mr6250311pjp.77.1585866061190;
        Thu, 02 Apr 2020 15:21:01 -0700 (PDT)
Received: from [100.108.66.22] ([2620:10d:c090:400::5:7cec])
        by smtp.gmail.com with ESMTPSA id w27sm4444215pfq.211.2020.04.02.15.20.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 15:21:00 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Li RongQing" <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kevin.laatz@intel.com,
        ciara.loftus@intel.com, bruce.richardson@intel.com,
        daniel@iogearbox.net
Subject: Re: [PATCH] xsk: fix out of boundary write in __xsk_rcv_memcpy
Date:   Thu, 02 Apr 2020 15:20:59 -0700
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <6BB0E637-B5F8-4B50-9B70-8A30F4AF6CF5@gmail.com>
In-Reply-To: <1585813930-19712-1-git-send-email-lirongqing@baidu.com>
References: <1585813930-19712-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2 Apr 2020, at 0:52, Li RongQing wrote:

> first_len is remainder of first page, if write size is
> larger than it, out of page boundary write will happen
>
> Fixes: c05cd3645814 "(xsk: add support to allow unaligned chunk placement)"
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
