Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 288717FFC2
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405648AbfHBRhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:37:25 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:35750 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729364AbfHBRhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:37:25 -0400
Received: by mail-lj1-f171.google.com with SMTP id x25so73680948ljh.2
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 10:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AT9yFlq6pVexGeSrCyoqveNT7hHZ7aCvtvvfHkjrBGQ=;
        b=jzn5pSGT8CN8ogsJGGS3k71LpfishP6oeiNwEe2s5GG/Z+dGxbE4F+aBihYSJ64FkY
         sSsKaAQiwUaKmL8YLEk4LMFi7Ul0RYZZQzjLc8JnngexaQmD0BMu2VROIaz33VpI6ZBI
         TT1cIz6Hls4APPh79wQA9K4UH5OFY//W3VAau5kgxEnqwzgLaeappj5BMMrWhE9l46RF
         Fd+zIz/7gylas0Jmv6FmPRcWG1EcKPB3kGb85292bIseU+0FgF/2JfuvJGZMOQYc6Ht/
         Yfk4j98joMAUoN7NDnftK5zOB3uc2MSR7srGiiKDyLCcFzNC9ZR0UNr6aaTCg+mVTjir
         fW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AT9yFlq6pVexGeSrCyoqveNT7hHZ7aCvtvvfHkjrBGQ=;
        b=Wemzh9M3/97OIzakdHyWQXzXgKh4sHrKRgl+teHHA8Zr3i4fbK5nPwFI7Q7/MQnl71
         HJUrUeTERVZscEIxwLUdVF+BZGqSZcbGkxXfAlfBuG21cZQ5A2hbYZ/f5LZh6Wsx/KRS
         fk5u5rWPtNo0Zyen6rku7PxpA1D0O1Hyvk+lZ9BtcrQK1553O2E2YZmcRw0IT9nFpbV9
         zfOtznTQhPNGCRqKsX5a/U48JmiOCydckZgRzNioTIc8yE4SC7uu3BGlFGISlX93qCSX
         xBYJGz6UQlzBWzXDN4162w2Y59Oz1kTlrxvXbSB4ee2IH8ongu5fp9CXyK2yRGsj5tTq
         43JA==
X-Gm-Message-State: APjAAAWDQFJiP/GPypoTx8hIk7dO7eRIkx7A5wwVF70A7DaSxh0WWGSl
        ccC48FLnH0zUdpsu1vqb/JSQObdcpmB0CZKcDdg6XA==
X-Google-Smtp-Source: APXvYqyFSOh+BOdh6DSMsJ8SK+3pHoWgv/DnKptc63jbHGxPNVBXUcEvqbP9c4nKwNXewBYx1rQBGUNo12EZjoRLmxY=
X-Received: by 2002:a2e:93cc:: with SMTP id p12mr7179611ljh.11.1564767443545;
 Fri, 02 Aug 2019 10:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190801195620.26180-1-saeedm@mellanox.com> <20190801195620.26180-2-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-2-saeedm@mellanox.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Aug 2019 10:37:11 -0700
Message-ID: <CAADnVQ+VOSYxbF9RiMJx4kY9bxJCS+Tsf97nsOnRLvi2r6RCog@mail.gmail.com>
Subject: Re: [net-next 01/12] net/mlx5: E-Switch, add ingress rate support
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Paul Blakey <paulb@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 6:30 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> From: Eli Cohen <eli@mellanox.com>
>
> Use the scheduling elements to implement ingress rate limiter on an
> eswitch ports ingress traffic. Since the ingress of eswitch port is the
> egress of VF port, we control eswitch ingress by controlling VF egress.

Looks like the patch is only passing args to firmware which is doing the magic.
Can you please describe what is the algorithm there?
Is it configurable?
