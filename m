Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C72518E3
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732092AbfFXQnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:43:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43005 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfFXQnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:43:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id k13so1242786pgq.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ht5kbQ1YuVjTnohWz8iOLfLwpx1pgLqUqBf1+CiZKLg=;
        b=KZrlVl+R184nbPAz4HzrEw52MA/uDoPq73Eh+GNuEqOBez7GNqZM2Xj2xzkuA1f5ka
         EY+eRE1pafE1dkf79fj6DSOqiYEC5aOwKfsRSJY5LndE3FU05MsdPEkMLXrCxqt9eKG2
         3aFxUO33euzdCLGlrs44VDyuIW7RGmc82poxJ0SXVD2cdGa1G3503jB2OczWWdORYZ8Y
         TY1wgoVT9aMYleLSdKi3dkd0e75VeuUf2eDFJdPlpUoCXEQ2+/7fzbYqEsyGy5b270el
         Kb7TUuYcnpPbaLEVG9vVqGdI8/oYnww9whpCmMcYSdjXwnGY9D6Op2AYRsIyeuDmjo5F
         sfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ht5kbQ1YuVjTnohWz8iOLfLwpx1pgLqUqBf1+CiZKLg=;
        b=AhD90y6LpMVnAHrfLbhaE1L52oSKsdPGtCwzukJXFMPld1gXeJPnNyqRUjNSeIjmYU
         0ACR2//Dvz9Y9jzLjOKU3THeJ34XblbMb42ko1on9wYu+gv2WyMKqnRMC0CpwE0fu4OC
         zyWJp0nJcpbjTxY4ggaDFD+b9MNUtRq7CD5v7i6Nm75NZI/mO9LYkJhDAewSnNR/M44D
         ipWk+1XhXy7JBAYd2zd4MFyqF9kuaGJ0EeNGlck6gF9oAwQrCUxd8UhPuykpsnMLT9Vw
         79NElAtZE9Nrw4k7z5XS/c29Riq67qGQsL1Zks1GsSajII14DLZbZkdmEni8lbf+rLWm
         uing==
X-Gm-Message-State: APjAAAVRA9nawDqSpLAvuhHkOtMXwlAChQEGHdkkuYMhsxlGW5kKtWBU
        qHJ34jpS0pJ2zVRceDNrW6A=
X-Google-Smtp-Source: APXvYqzWX1BVLEcG6T7StfXUB7XbMiWdiRu3ct35OSLd9xSiuDxHXZFqfDTMHc/G+L9GHJ40RDbl2Q==
X-Received: by 2002:a63:5a1f:: with SMTP id o31mr33405682pgb.254.1561394620995;
        Mon, 24 Jun 2019 09:43:40 -0700 (PDT)
Received: from [172.20.181.193] ([2620:10d:c090:180::1:73aa])
        by smtp.gmail.com with ESMTPSA id r1sm14033385pfq.100.2019.06.24.09.43.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:43:40 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     netdev@vger.kernel.org,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH bpf-next v5 1/3] devmap/cpumap: Use flush list instead of
 bitmap
Date:   Mon, 24 Jun 2019 09:43:39 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <1B6B072D-8DE7-4468-8DD8-C1CFFD145525@gmail.com>
In-Reply-To: <156125626115.5209.3880071777007082264.stgit@alrua-x1>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
 <156125626115.5209.3880071777007082264.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Jun 2019, at 19:17, Toke Høiland-Jørgensen wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
>
> The socket map uses a linked list instead of a bitmap to keep track of
> which entries to flush. Do the same for devmap and cpumap, as this means we
> don't have to care about the map index when enqueueing things into the
> map (and so we can cache the map lookup).
>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
