Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F533B36
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfFCW2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:28:01 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42254 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFCW2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:28:00 -0400
Received: by mail-lf1-f68.google.com with SMTP id y13so14828124lfh.9;
        Mon, 03 Jun 2019 15:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZWvk/2XMyepsTUJHMV7bC6trBdjUZs/VcC7h+8Dj4xs=;
        b=ZpiWSQbX2R6AXiGk6SbdDWikTXjUYopj4EmSeZO3lomxXQMIEWFPFpq8aR3k4LThzH
         9+NC9aGMRKA7diA2wL3csARuGzNKAZLt6tLSg5aB9Q0+rjF/DLjS0r/ROxXgNqjk2rzu
         tqY/W3hK8Backozx58QMrySYqi4N2xDJLCGTUjjMaK6NwF9MQsBrwLMHk+rVsZwnZdTH
         wCnKikCeJhU8deckqvhvU9eXe9R1HcFM7h5AvKW9Ts7exEWmvVeOZjX1kYjnIhx45IU/
         AMpCehIPGw6CPmvmi+bbeEOCYItTbAfu3nqu5Jk3ilTvtUiG0I6NNF59bvQKeweZUczD
         m+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZWvk/2XMyepsTUJHMV7bC6trBdjUZs/VcC7h+8Dj4xs=;
        b=iEZ2BGSagBsIeqFy/skSlXNHbmlEIPLwsxIa3xG6RUXGCoZkZXY4KpWC+9xEgwzEKh
         hT1n+4YdwctJrHa3oTIVPVD7y29xUsJ+ZwGfINIBr7/Hs0Y16D6eZ8Uzd4gmdSUjrowB
         9jLOg2sNr062tG9F5beJGA3jo/C724SB0nhlTu/51dDCGi8Gdf2hmZbBb1KRWqJqJCFt
         f9kafNQH+cMGApKdNzBxPoTxk2kwWRhQVb12cN68OhU/pbmDyqctomLrxmROSORp6c06
         Z52i5PrY3f5hvtLK9UTCpDC+VqKaIHjPgIp0DYLpgMC5YF3KtbCTfbS6ysbbfJYTa/Yd
         1TiA==
X-Gm-Message-State: APjAAAVTx92rqO8B0DbocjjcMUSQ6oG6/7kfXrsdoETHDGbG5L5BT51z
        FWfmozHwEC8/T9WW0Yef/TmauUcMDK7QTC1NVi0HEg==
X-Google-Smtp-Source: APXvYqyq38/kbhI76sUrRbpq1BquI74C6HVGelaO47iOOOdTJ9bVHjkK3ccvPGLuH8rkOun+tqbUEbgvQLmZN+2P56w=
X-Received: by 2002:a19:e05c:: with SMTP id g28mr70057lfj.167.1559594540932;
 Mon, 03 Jun 2019 13:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190531222910.2499861-1-kafai@fb.com>
In-Reply-To: <20190531222910.2499861-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 3 Jun 2019 13:42:09 -0700
Message-ID: <CAADnVQ+3FyyCzZ=XhhVsHXZXcuyMgu_khHrxqz9YQ-0=kHPe4Q@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] bpf: udp: A few reuseport's bpf_prog for udp lookup
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 3:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This series has fixes when running reuseport's bpf_prog for udp lookup.
> If there is reuseport's bpf_prog, the common issue is the reuseport code
> path expects skb->data pointing to the transport header (udphdr here).
> A couple of commits broke this expectation.  The issue is specific
> to running bpf_prog, so bpf tag is used for this series.
>
> Please refer to the individual commit message for details.

Applied to bpf tree. Thanks
