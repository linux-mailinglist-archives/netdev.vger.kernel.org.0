Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF4716AC45
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBXQyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:54:38 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41246 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgBXQyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:54:37 -0500
Received: by mail-pf1-f193.google.com with SMTP id j9so5645269pfa.8
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 08:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jz9ts4SCtKZj37NIPf8q4/BPLrwc/osDKFjhv7rsDeI=;
        b=tRkgNoX4yJhq2d5BmyfWy8mpkG4kC5+XKVPug3Pci6UF4uEEf2kXBaopNRhVs4i3DW
         k0Gc8JctiyRHscnKKtxyXy5h7B7cLp62sXtrkkW3jpAv7dOYt7AIjzRhbIRC01dOZLc7
         Q6LA/wbFEkb8Rvjtu9J0IPZO2TsfFbvbo9uVaXMgJ8AeXjQXie0GgkuU3M338nu3Wzm6
         67CzBqx5fx7TkVKfIH33zZ5zo5W/8anAfqWUyKanHz5rVYSeCLi390iZ4fUYKq4Zkjn0
         5s6Dx5EKZI/usIGZKq/+d6pqsNErugR12MOKa666p5TEIdizgzGkExzmyVtkvbqXEvAt
         ua0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jz9ts4SCtKZj37NIPf8q4/BPLrwc/osDKFjhv7rsDeI=;
        b=cqgoJjFAl3XM57TfLNsRPz5GB0SOr5BYCMCG7Zx3LS+Wc4uEYjK8nsLnRlBBQ1y7/o
         37o0eDOuBMvh1aACQukke8IUwk3pNA67CcKSgwgUxssJ1JHk9art9YrzCXthVmugx3Yr
         lUp2e9W9o/UkKjkSUCvIQ0IL1tPXmd3HH8h1GrAq1z5POcTGEDhOKRv+zWOCiByUcVHR
         eQLlhyt55WMWCz0C3jGejqz4YHw1c940h2B8CJh/E/cD0hbQT/wb9cEXFP2F+gUXu/+X
         vHzpMu2hBiPUA/N0IRKAkgVV6XvtXRaQMFyjf4eYCN6WhqDssBKjB0rCUANe/4ps7pi2
         hHmA==
X-Gm-Message-State: APjAAAUYfIS576xEIHlvS9s/t8XUJpZtETbnUO8thF3A8ZaGwWJQHgGG
        +nCENoaE2UPQ9yalkXXpHgWnMQ==
X-Google-Smtp-Source: APXvYqzNgEvVHwwYp171vq+DGUKIznXT5NreSgy9nkOB9PXvTHLAnh95EBienIEWE6Q2TXU8zVuOuA==
X-Received: by 2002:a63:594a:: with SMTP id j10mr55004172pgm.227.1582563276024;
        Mon, 24 Feb 2020 08:54:36 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b12sm13755654pfr.26.2020.02.24.08.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 08:54:35 -0800 (PST)
Date:   Mon, 24 Feb 2020 08:54:27 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net v2] net: bridge: fix stale eth hdr pointer in
 br_dev_xmit
Message-ID: <20200224085427.0358ed8c@hermes.lan>
In-Reply-To: <20200224164622.1472051-1-nikolay@cumulusnetworks.com>
References: <83cadec7-d659-cf2a-c0c0-a85d2f6503bc@cumulusnetworks.com>
        <20200224164622.1472051-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 18:46:22 +0200
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> -	eth = eth_hdr(skb);
>  	skb_pull(skb, ETH_HLEN)

you could just swap these two lines.
