Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9EC1BBF9
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731782AbfEMRbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 13:31:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34424 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbfEMRbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 13:31:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id f8so6580547wrt.1
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 10:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CfxRL343wAC/ONpWSbgUzWCYCrJkv6Umz/+oMCt8e8M=;
        b=vN0Y7Rg/zsCx8OHmPLzi4lWRUIGDf6ukbzCKJCd8mVCrHl7Ymv12uWgTEwWgR/BUsA
         CWrYu7y5Fwd/iaLTA7dO0yOwjRVBRO2UOBvWLqK/iyMC8cR9TWrJNiNdZ1+iWG+L6pY2
         wsq3dBDC5sQ0CRtK9DRRueJtzceGI7AoTVNhFI2tSRVc+6gvW6/daj9lH+ZQNfNCc1mr
         UFNY4Lclyc8NBmKxm7hHIM59kCBju3LVPtwc5RoP3pbQYRr8td58bB9O/f7uuRObries
         og3MsZmvhlaDcMpdoRteplozIWk6LtX5BVwy/7PkBMl1aF02XgMbL4Q4/saor0FXW3ai
         cQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CfxRL343wAC/ONpWSbgUzWCYCrJkv6Umz/+oMCt8e8M=;
        b=f8oXB4zb9t9iKQ/4KtE5ePGPF19K8zxR+Wgft1McGAmY7oO150wOV8osA4Jz73l57s
         P9c9tQpr8rP9d9fc1LFjsPFYtk3hk1d4TnCgrGkr4TiuZpGxOAaYCN58Uvw1HFV93Asp
         Z0KGHZfuKmEYfqY1HdWNViDP3TvqiBH4w1WlEcVefuW6Ol5d32TZAO+db9X7zYRdXPfF
         Bj1cCZLkWD86b3XaP0hg2PDoFAPsT91Fw18RkSTClyuKPFtPBrRUZRSW7+LnL2ACg6e9
         AEoStQB5XTEzuqTofyiknlm+nEQY7k+JewK0XAsnJO/PLXxMzi5WrM9teVPyiLGN7IzO
         GAKg==
X-Gm-Message-State: APjAAAXuXeWNHDaB++DiZSkwhH6cUyhNFKkYH3qICqbG54oJbvVrTHW7
        Aig78JgTS1/3U1nf4UB6TDrsvxaPKSGfuF8wOmX/Cg==
X-Google-Smtp-Source: APXvYqz8W4B/sA+Js0yRgAlFzlVGKoJ5QOo7kJvEnKnsDUP5BOCmP5UEFeADv6bqBaEopmV/uVrtgp0vdi0vKVGDhP0=
X-Received: by 2002:adf:8189:: with SMTP id 9mr15774885wra.71.1557768709022;
 Mon, 13 May 2019 10:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190510230019.137937-1-ycheng@google.com> <20190510.164142.2254976888525470430.davem@davemloft.net>
In-Reply-To: <20190510.164142.2254976888525470430.davem@davemloft.net>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Mon, 13 May 2019 10:31:12 -0700
Message-ID: <CAK6E8=eQ9r1XG2U+=qn1VDmp54O9MGZm5DawBzWtJoZsrq7JzQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix retrans timestamp on passive Fast Open
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, May 10, 2019 at 4:41 PM
To: <ycheng@google.com>
Cc: <netdev@vger.kernel.org>, <ncardwell@google.com>

> From: Yuchung Cheng <ycheng@google.com>
> Date: Fri, 10 May 2019 16:00:19 -0700
>
> > Fixes: 3844718c20d0 ("tcp: properly track retry time on passive Fast Open")
>
> This is not a valid commit ID.
Oops submitting a v2. sorry for the typo
