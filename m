Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FCE1317A
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfECPwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:52:16 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45400 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfECPwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:52:16 -0400
Received: by mail-yw1-f65.google.com with SMTP id w18so4626418ywa.12
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 08:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cglHYBBihEYW7EKc6k81VJmdyePJKglzrezHfBYFZpg=;
        b=ZJC+aj6PuAbOvpe4ZoFRK63e9H7B0KqgirDW+FKPSJO5sQb1xBwcX68zf15WWL82l3
         w/9trqpvrhSUeiFQ4vil65M2AMU7g+Tc730khGBn/JX6IniiIWiSqVAh4TfJebYYgvEF
         q/wyMrzA4JKMTUvfbCn205lR34jifP71Cz2Ya7MtImmyHcttacOgaxU8+THjfsygoZhE
         U6abtPGquAxoxllI0cQdDSl/94yb+ulqHKlGzlRJVQEoPu7mi2DMAnqGF/GuIVrbk485
         0oXiGJNpBVokccMahq4gN2nTFka0LU25shsBOpz5wl5qtxZd8n96WmkA3Bv9hEI2SOD0
         TLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cglHYBBihEYW7EKc6k81VJmdyePJKglzrezHfBYFZpg=;
        b=EN6dNGlrvCPf60Hjjcr5aNU9YBpinw5IxoAEwaX9lK28I3Qon5jSPrSujH7NrUOi0x
         ONV0LaW+6851wMl5PMqAisGWxNJgUrAbjUVM7gdCuGSn1cE8uKKyOfZdoBo+hPSZjUTY
         11yNgyNMGlKuW+ko15JR7UdoETUhNSnJit5eF5OE9xLoa7pMJULm4IiE89ghmRgXWVJy
         1JhU8kZJlO48iH5+4snI2yr1JkJiYcTZM9gmpoY2JfkT+MdCThucllmPOI4Bi5YNIp6X
         H238zEoC1MKcYajGIQy2tn0138XVReOzUW0XPj3r4ukjG0PF0XEG6zZxqGbequBrmMz5
         mfQQ==
X-Gm-Message-State: APjAAAWMJJIETv65IsD+gfpE6kGtBwvQRC7Qr/6upfTFtXmXJ5YaG+sq
        0r4bg7OlI74zUqyt8uDGQ6nRjZ4lOtFdwOp9qhY+9PLUrks=
X-Google-Smtp-Source: APXvYqwxYFPx+sKSpd3sJR5IlzWyZuMSl1bfP0wNwKiPSPWr/dVk0ksFV/4ahIQHrvjBtCcbP5gvfaZwN2F4CkIsQpk=
X-Received: by 2002:a0d:c0c5:: with SMTP id b188mr3482061ywd.83.1556898734869;
 Fri, 03 May 2019 08:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190503114721.10502-1-edumazet@google.com> <CAPNVh5c-xeSaRkQgFtFUL1h3u0DpEozBXDP+xf-XEvXKbDgCYg@mail.gmail.com>
In-Reply-To: <CAPNVh5c-xeSaRkQgFtFUL1h3u0DpEozBXDP+xf-XEvXKbDgCYg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 May 2019 11:52:02 -0400
Message-ID: <CANn89i+cRBCg=7Q4W45z9HuwJoCHspMNRKZJw9ztigjUDryY7w@mail.gmail.com>
Subject: Re: [PATCH net] ip6: fix skb leak in ip6frag_expire_frag_queue()
To:     Peter Oskolkov <posk@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stfan Bader <stefan.bader@canonical.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 11:33 AM Peter Oskolkov <posk@google.com> wrote:
>
> This skb_get was introduced by commit 05c0b86b9696802fd0ce5676a92a63f1b455bdf3
> "ipv6: frags: rewrite ip6_expire_frag_queue()", and the rbtree patch
> is not in 4.4, where the bug is reported at.
> Shouldn't the "Fixes" tag also reference the original patch?

No, this bug really fixes a memory leak.

Fact that it also fixes the XFRM issue is secondary, since all your
patches are being backported in stable
trees anyway for other reasons.

There is no need to list all commits and give a complete context for a
bug fix like this one,
this would be quite noisy.
