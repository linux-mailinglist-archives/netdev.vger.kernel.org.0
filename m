Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F31FA3AC0
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfH3Ppi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:45:38 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44809 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3Ppi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:45:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id c81so4872982pfc.11;
        Fri, 30 Aug 2019 08:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=AQcszAxJMGmzr9mcXZyzTqKFncOjDmo3mtAAwMQbfK0=;
        b=AFjjIfia0spTV6b4E9ZloJREqJlMRAGat+xANwqw8sWD6RbrfWq1uOVmZOqNWc7aNR
         aNotby77LKePdQECAx6xTE9dXfASNAqCQuJRUW6q+BqQViRPsNy9uPuvz1R4mU0k2nBo
         xh8FsNTZ7oC3rTr2O069gxAb2WDijZhNjzBMZXQ43g1epzZod4Dz4BTIxEVWCo60JuxO
         gMHvddyxBJjreD2fJXnhTWxiwnSCUBcoFlfJISfZcRR/T3SghTFOnJGwvQgbvIt6OWeZ
         UmY1QBRSAlhXB/ANdRfizXKmmfTc+wPeOnWtziXzWw92dOTYnVEYig+fNiGb7oYDFBdW
         oJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=AQcszAxJMGmzr9mcXZyzTqKFncOjDmo3mtAAwMQbfK0=;
        b=X6HAFwYv/eu17JBmCFtjcOp/nCpA4tLbE9A2jNo9cSq4WiTfM1Y0/475HJj3V9X9Du
         qbnl9UFWr+Bja+xaLbSEZ8//ZtPE+V9wJR43Kq5jT5DiHLPBixr09L/US88cPsx+RirQ
         /pOA5tVtepEQYmVWT4BmvBp3hEvFtFDLRkV/Sq2rhBGWU9BM+0sD8AIdtEE6gOGZvA7k
         AzMw+ogX/z/9PtmNMQznw6pp04SeieZdxrR0q6VQNDRLnV+SwdgIhr/5Yv0WUuaBCUYv
         zpr7PcHIrT+S4XuzLZq9JRhO2wvtDz8GJ6vCtbEftgSHyQlIiTLMmXrvWWox5Ucpd/NZ
         EFZQ==
X-Gm-Message-State: APjAAAXx5p/xCm45iB6xGK82CXBJ18ZuUHNwMhbcb1UHtLk63deRVmkS
        kOZke1QDj67Q0Ka0z9K80Fs=
X-Google-Smtp-Source: APXvYqztZbEcpjjL+pO9jnW+VurgE/+k1BJo2dvvu4XMbmkpdKaLXzDKOtW5gTMEu1j9ffQfGnhYlQ==
X-Received: by 2002:a17:90a:f986:: with SMTP id cq6mr5023902pjb.48.1567179937659;
        Fri, 30 Aug 2019 08:45:37 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id i9sm4920390pgg.38.2019.08.30.08.45.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:45:36 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 07/12] net/mlx5e: Allow XSK frames smaller
 than a page
Date:   Fri, 30 Aug 2019 08:45:35 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <C5FEBF55-CC52-4489-955E-1202BB4FF193@gmail.com>
In-Reply-To: <20190827022531.15060-8-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-8-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>
> Relax the requirements to the XSK frame size to allow it to be smaller
> than a page and even not a power of two. The current implementation can
> work in this mode, both with Striding RQ and without it.
>
> The code that checks `mtu + headroom <= XSK frame size` is modified
> accordingly. Any frame size between 2048 and PAGE_SIZE is accepted.
>
> Functions that worked with pages only now work with XSK frames, even if
> their size is different from PAGE_SIZE.
>
> With XSK queues, regardless of the frame size, Striding RQ uses the
> stride size of PAGE_SIZE, and UMR MTTs are posted using starting
> addresses of frames, but PAGE_SIZE as page size. MTU guarantees that no
> packet data will overlap with other frames. UMR MTT size is made equal
> to the stride size of the RQ, because UMEM frames may come in random
> order, and we need to handle them one by one. PAGE_SIZE is just a power
> of two that is bigger than any allowed XSK frame size, and also it
> doesn't require making additional changes to the code.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
