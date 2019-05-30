Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7040E30443
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfE3Vyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:54:50 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42391 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfE3Vyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:54:44 -0400
Received: by mail-ed1-f66.google.com with SMTP id g24so1633304eds.9
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sY2NlxkL9fH7yCO3DS8waNQq+wC2vGb4FJKSdPV+3y4=;
        b=a0zmmlYfQ5Geyhvg9t/bh7d8ULvmTAwEAtnDvmhrkmmNAyD1gfuWkoeJBFk9O8FF2t
         f44K8qxcv0OKjbIqw0pdO3UnUfcPs1s4WwtAaeBbpy8JUehacX4t4oxsE++XYWeDo3up
         +MgLw2nwyKs2dPc6p/hGCAepHTSDEYzBTYFydV56UuJBQhLk+kT6QMuxwYWPe3zDuLee
         9oEdFK0bAntyFb5wRQ0U5BxfmzQremqJYflosAI6w/kOEb53qPOw+6dYkx6WM7PjAUGg
         paizhTOJOqG1TGVZPgbnSgo2SKaLf4F9MTBCm6Odgd3aHSvtcKnp6Y9yjnlxxGYYqGka
         3+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sY2NlxkL9fH7yCO3DS8waNQq+wC2vGb4FJKSdPV+3y4=;
        b=NQYWYgcBsO/E9mXxOucPmoIVpIv+S54/EEW2ETe9T8NHqPypNf8ZAP4oC3xo3rD5YI
         EIukEo2UygmRbWxFqpOLVv8zUm3lGC8L5gBiWw37AllwgidfSj/LjuLqODoCZuETwNdq
         8uM8qQxmXg3bYLZWLFTAAbP2CDcMW0Nv2gsi1uzxOM/w6mUvkkuq/JEVa4E9BfbdbZCA
         Ber+XWc55b2yHeGlRH1ykDhqU4jBW2ceR6/Aj1NJ+YBpz9MTYi8TBrGLHY8PsY/i4Hce
         HiQteDc9mfXLr5lihZuazLFZfhbob0sSWNEPkpOD2uY6zxTGGticmlt+4H1atymWixje
         OJJQ==
X-Gm-Message-State: APjAAAXSpoo01/+1npp2Lt1/I8c9rUJ4CNOQhnzNBiGcozr5iAWQLp2H
        2/VpMwPTjQ4/qnHI9YPHSayJtCZUfHB16FhfBG0=
X-Google-Smtp-Source: APXvYqwdRVT18XDY4s/WNat0ynM2Lgb3BGK70THMHAaAZ1s4CAKYD68K6HXq5WXQMyJ7zI3vqMzOxf4LKN7Ezo6PqRA=
X-Received: by 2002:aa7:c645:: with SMTP id z5mr7361575edr.43.1559253283012;
 Thu, 30 May 2019 14:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190529193357.73457-1-willemdebruijn.kernel@gmail.com> <20190530.144442.1709791688381360238.davem@davemloft.net>
In-Reply-To: <20190530.144442.1709791688381360238.davem@davemloft.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 30 May 2019 17:54:06 -0400
Message-ID: <CAF=yD-+t_BXbAk1NAF+Nr4dV0WFBvjdd=scUtb_FoM1JuNC7OQ@mail.gmail.com>
Subject: Re: [PATCH net] net: correct zerocopy refcnt with udp MSG_MORE
To:     David Miller <davem@davemloft.net>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 5:44 PM David Miller <davem@davemloft.net> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Wed, 29 May 2019 15:33:57 -0400
>
> > Fixes: 52900d22288ed ("udp: elide zerocopy operation in hot path")
>
> This is not a valid commit ID.

Typo in the last character, sorry.  Should be

52900d22288e7 ("udp: elide zerocopy operation in hot path")

Will send a v2.
