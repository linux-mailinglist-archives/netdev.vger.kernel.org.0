Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D0A263B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfH2Skb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:40:31 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:39354 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbfH2Skb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:40:31 -0400
Received: by mail-qt1-f182.google.com with SMTP id n7so4818995qtb.6
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UNQjdAPsazREfMb5zPtQampv5Oynbe8KnmbemVeE8Yo=;
        b=fqyIBIuIJjheHKYjsRGoKHkODTvTdE4/WE5LGfFWjVBCA+GIvfbNK0IVn8d3nU0TZ+
         XX9OgzwV+FwmgyA82aRXDUWASbjyMOpNUe8gpv+TSFs1k1XKZDF6gHPWQAG3mBpF0O22
         aKkFYQkNXitHUoHz2ufsp6TFi8hPihlGnRWVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UNQjdAPsazREfMb5zPtQampv5Oynbe8KnmbemVeE8Yo=;
        b=molKwkrHp0aIKn78z/Ifl5HwVBYVpKIAERuZGQz30A64hd7IPOhlt9k6NBcKbUOyP4
         tUzKaGBpCPUXDa9xie22qDFsmPCXjaM2dschBYg5b+xxRDo0Y53O3xcJDw3ko1R3wbOn
         wCPeRe8edV13FdQkdbpPS4m778Z2TkW3YvgWaCzlHpsbd/avG9gNuppsP7oOr8Yjari4
         fByjrdyJUjmTKQYX76x8PY77D9ZFlDhhGdbTLt3ZXfwsaT5fqGmHpftxUSxpyQtWWge+
         lval7hts2lzfML59CiQ2+lwfWmwUDoM+TVZQ42aPW/DRiywHgA64XdGikljppWcO8Gci
         0IoA==
X-Gm-Message-State: APjAAAVLzgvX9tuaivLLmv8BqD+JE0vx6PLecbAaqMNQJLt+kWYhWicL
        Uuns4sa/yOJ65NDTVZDmCorfz/iESvPUQNE/Tw2IxQ==
X-Google-Smtp-Source: APXvYqxpTDdwNhhD10NA4ev7zF6wYONF9gUWQkBJQtpkwFTnjOnFzeLXH5A/mBI4eFK+FHE9XLykkScHcAg0nxi/ILg=
X-Received: by 2002:ac8:478a:: with SMTP id k10mr11270826qtq.117.1567104030207;
 Thu, 29 Aug 2019 11:40:30 -0700 (PDT)
MIME-Version: 1.0
From:   Prashant Malani <pmalani@chromium.org>
Date:   Thu, 29 Aug 2019 11:40:19 -0700
Message-ID: <CACeCKacOcg01NuCWgf2RRer3bdmW-CH7d90Y+iD2wQh5Ka6Mew@mail.gmail.com>
Subject: Proposal: r8152 firmware patching framework
To:     Hayes Wang <hayeswang@realtek.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     nic_swsd <nic_swsd@realtek.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The r8152 driver source code distributed by Realtek (on
www.realtek.com) contains firmware patches. This involves binary
byte-arrays being written byte/word-wise to the hardware memory
Example: grundler@chromium.org (cc-ed) has an experimental patch which
includes the firmware patching code which was distributed with the
Realtek source :
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/1417953

It would be nice to have a way to incorporate these firmware fixes
into the upstream code. Since having indecipherable byte-arrays is not
possible upstream, I propose the following:
- We use the assistance of Realtek to come up with a format which the
firmware patch files can follow (this can be documented in the
comments).
       - A real simple format could look like this:
               +
<section1><size_in_bytes><address1><data1><address2><data2>...<addressN><dataN><section2>...
                + The driver would be able to understand how to parse
each section (e.g is each data entry a byte or a word?)

- We use request_firmware() to load the firmware, parse it and write
the data to the relevant registers.

I'm unfamiliar with what the preferred method of firmware patching is,
so I hope the maintainers can help suggest the best path forward.

As an aside: It would be great if Realtek could publish a list of
fixes that the firmware patches implement (I think a list on the
driver download page on the Realtek website would be an excellent
starting point).

Thanks and Best regards,

-Prashant
