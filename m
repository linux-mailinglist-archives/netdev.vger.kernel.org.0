Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3216F107E73
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 14:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKWNBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 08:01:19 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33806 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfKWNBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 08:01:18 -0500
Received: by mail-qk1-f193.google.com with SMTP id d202so434865qkb.1;
        Sat, 23 Nov 2019 05:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AR+g5s2RaHH37zk1i/RKopekgIwJPM6yuVOq46MIfO4=;
        b=BkBIk1ykI4pWH+YO/OiV3nXU+4NNSWtOFzXpM16SSwKucLGY09iDMyGTN6GGMUVfoz
         nw7xL2YrkWV0am9oQ8GUs6c+u70rxwUmDSI9KsYEXERbO7xptoxBMd1ArLrkEXQQB3me
         8Zm8U6wmGIbcGPqZkK0gRQ4H7Dmi84T1xPHPaYZXGXZkdjNJebKUuibDqx9iEo/P+hSf
         nCktZrC2na4QGy2Qov9xMAhLUISnRgd2IcQ0nrkG+jt0KBeupW+wTro6MGP0LWD+I0yC
         SLrLFVNCikgnNS8Hck+ApR9vkk3t2c97tgkflWhhIDVcdh5vu13nhZ97bVQb5ctCknwy
         NtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AR+g5s2RaHH37zk1i/RKopekgIwJPM6yuVOq46MIfO4=;
        b=V6Y8CoqUkIIqcalT7Xlaoq1HkEupnC05TFDlC+tv+PieQ46YJCZ/+BIL11fuSmEijN
         EMY4arDj9qsqaUJyTHJoYQqcna63irrlobicfor6OEfzEJEqXSnctKfbe0BhsahBePFd
         woNSvKAgiamNgA/2H1iSELYfkmLdVsAj/QI14ZbrTplEYzSxrwccLtZnxSbLs2g5qVNj
         OdyawHetRxbmkv6GfUFC3yfhjTIUGCxOrdlVXGYXyQAi3FkvRlHLXTe6A8nT0PbMmvqX
         Uu/lj2jNnU5N9CjOnwr735i/665YNkPwS5BfyUxjW3qAeR1H4npD8yZNScKn14duQNEs
         YDFg==
X-Gm-Message-State: APjAAAUL2E3+DCN+SPEbEevimOraBLGIBvGCLQ3tdeRXP1aZebEFcF9M
        bp8tu0DOllb3pBZMhUdEa18=
X-Google-Smtp-Source: APXvYqzMF8JashUZraVBVCEKjo77zK7UVyp8KgoXuEJQYwgSe7wZtsNYoBu7eVOptPxqUAJMPpTieA==
X-Received: by 2002:a37:411:: with SMTP id 17mr3124406qke.40.1574514077320;
        Sat, 23 Nov 2019 05:01:17 -0800 (PST)
Received: from localhost.localdomain ([177.220.176.157])
        by smtp.gmail.com with ESMTPSA id r4sm603450qtd.17.2019.11.23.05.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 05:01:16 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7992CC4DB7; Sat, 23 Nov 2019 10:01:13 -0300 (-03)
Date:   Sat, 23 Nov 2019 10:01:13 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, emamd001@umn.edu
Subject: Re: [PATCH] sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook
Message-ID: <20191123130113.GI388551@localhost.localdomain>
References: <20191122221759.32271-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122221759.32271-1-navid.emamdoost@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 04:17:56PM -0600, Navid Emamdoost wrote:
> In the implementation of sctp_sf_do_5_2_4_dupcook() the allocated
> new_asoc is leaked if security_sctp_assoc_request() fails. Release it
> via sctp_association_free().
> 
> Fixes: 2277c7cd75e3 ("sctp: Add LSM hooks")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
