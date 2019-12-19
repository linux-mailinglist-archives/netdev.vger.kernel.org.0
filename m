Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D75126FEF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfLSVq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:46:28 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]:41483 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSVq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:46:28 -0500
Received: by mail-qt1-f176.google.com with SMTP id k40so6343370qtk.8
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 13:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VO6Oa9byymwyW6n23ILZAJDl6f5Ys1IOFf5yRPmHuPo=;
        b=LzRhNFGA5iZor0jf32Zm9YWEhI87EluLTGg6MUh3iGNs6XNwn0UTbGxldDCEF4IOfz
         3DsLwGj94OyxxRUwEXEOz683yvpPPgpXQ8XvqTJ/DnFPn/0tYWAff+ABqyS6abz0CkeH
         cHPthvsyIRSJL8qxrYA9agRd7wyidVd/liGYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VO6Oa9byymwyW6n23ILZAJDl6f5Ys1IOFf5yRPmHuPo=;
        b=IuyTS/C13Fij6547EAr/GsQYks8MTfUVgXLtZvwlB4hlaUO/62Hbq+scHUwwApQdMp
         tsBkhxGGFzV1OFyZGBtzXqNFkVCPozzRl4iA7zZF1YDRMsQ1+8qdXRxOIqKgGKZx2mn9
         DJ0UI7cklfYCevkoIgsRWSD+xKSlgSl9ylHBSd9Ziiu84zAmyX25EdVeEgxJbu1UkSo4
         v5MozCNsG6FSfreMAONvR3opdvncTX0w8JsQHFk+UNRZShY+wl+MaJJ5Pte5CRy+hTcl
         iM42F7YmTflMyWsJ7cU19MthgdlkoQzZQR0nR2+0o/jwB6E0ghXxcqy4OeWSNiEzrMTx
         zIQA==
X-Gm-Message-State: APjAAAWMcbVXbeCtZ87BxdUamONGFWZuInfoFiWstY8F+uyM+bKqZVV8
        Nkw5N8HO6b3pS70cvO4qiR4NUdEUCYNpcY2Ae+M7tt0+sW7NTA==
X-Google-Smtp-Source: APXvYqwpqC74xeUMj8yQEwAE+ZczgnB/Uh/jOqqfs4iRaiimV06OcME38a4mJLo8X5ezJq61ccNR97lNfS0+INihS/4=
X-Received: by 2002:ac8:602:: with SMTP id d2mr9200816qth.245.1576791987660;
 Thu, 19 Dec 2019 13:46:27 -0800 (PST)
MIME-Version: 1.0
From:   Alex Forster <aforster@cloudflare.com>
Date:   Thu, 19 Dec 2019 15:46:16 -0600
Message-ID: <CAKxSbF2XaqwLAby0BBbhT_8vBviMvkA_7fiK-ivAs2DHWqARxw@mail.gmail.com>
Subject: getsockopt(XDP_MMAP_OFFSETS) syscall ABI breakage?
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The getsockopt(XDP_MMAP_OFFSETS) socket option returns a struct
xdp_mmap_offsets (from uapi/linux/if_xdp.h) which is defined as:

    struct xdp_mmap_offsets {
        struct xdp_ring_offset rx;
        struct xdp_ring_offset tx;
        struct xdp_ring_offset fr; /* Fill */
        struct xdp_ring_offset cr; /* Completion */
    };

Prior to kernel 5.4, struct xdp_ring_offset (from the same header) was
defined as:

    struct xdp_ring_offset {
        __u64 producer;
        __u64 consumer;
        __u64 desc;
    };

A few months ago, in 77cd0d7, it was changed to the following:

    struct xdp_ring_offset {
        __u64 producer;
        __u64 consumer;
        __u64 desc;
        __u64 flags;
    };

I believe this constitutes a syscall ABI breakage, which I did not
think was allowed. Have I misunderstood the current stability
guarantees for AF_XDP?

Alex Forster
