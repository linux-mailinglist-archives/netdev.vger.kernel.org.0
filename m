Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2655A195695
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 12:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC0LuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 07:50:21 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:38487 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgC0LuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 07:50:21 -0400
Received: by mail-vs1-f65.google.com with SMTP id x206so5989921vsx.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 04:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+QYqH1izi7DEZLPMDt4dsGYQrJn+m3Ne0vPWoqpxZ0o=;
        b=PuC5PkC7fSy+9qKQbhvjXCSaDltDWI8kQ5+wNpdOitrekdpmeK/7FA2/YQr29QI3IP
         Bh8VbgahV/nKQy3FuJ4m+dvHv0eMyaU428UeojhSAjzBijp70u97SPpV8C0yaXLXHOaS
         A45wyGCEGS7fZwfv3OOCx6gQGhcHoDTaBdGiA0JMxav21Mzw2jSUDe4if5RMZZRy8dAm
         3n3jcdDQuSJAoLIHIgEhWZ/uc1EeujFTds5VBeNtgN2fDtBQb8qkfocGQquOyI6loCnt
         UKICzooBaxc+oq/M/Kk8CdIkcBqIvWSJUMFQDjSBQWexlPCKlgCPYxeAdYKxiMv654e3
         nbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+QYqH1izi7DEZLPMDt4dsGYQrJn+m3Ne0vPWoqpxZ0o=;
        b=LR4tjBVwEqzSFULKD0OtZVGWZJ2kw7X8VYRVwLfL6ZebhggwrUMBhEFVh/gHc8xmfY
         9mxuUiVTrPM8V8L7NpVjT5yy12PeA5PWsP6fcDFMV86KFDt0eWYytYpCp3GoZhV8iKjq
         A1uF9/bfuvRPOgnCSnrAh1NX+1Tj3zfEEri4Oe4tc2cvlrlK+vkZ35sEl2qWJW4outP3
         WhJE/ZU4DLK7tA0ev/OI2zTaawkEm3GzjYwMIGvSq5zehECGbHoB7oW0H41qf7/KuIWb
         uePrTTYqjC8HXHqRHPAagmCJtXaWuGeInxQWhj9CQwplROm9uz79O2hyOZ4i2ggFmJWr
         d9/g==
X-Gm-Message-State: ANhLgQ2eU9+ojj9VhYcwymgSL+STlBDdogBivFHcmOWSP9rhI2zYUnK6
        ipcrpwZZuMA3ScpRG0vVu4QIg72Ya/oxbQzXblE53g==
X-Google-Smtp-Source: ADFU+vtOIKCYOE6WM68l+XyEbnfItZ7TuSuqUMlFuh8/Sir2Grv3B726059emGiMrBfvnTGGKxyyrBi4JSdq8ErdlAk=
X-Received: by 2002:a67:7204:: with SMTP id n4mr11432296vsc.195.1585309819757;
 Fri, 27 Mar 2020 04:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200326094252.157914-1-brambonne@google.com> <20200326.114550.2060060414897819387.davem@davemloft.net>
In-Reply-To: <20200326.114550.2060060414897819387.davem@davemloft.net>
From:   =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
Date:   Fri, 27 Mar 2020 12:50:07 +0100
Message-ID: <CABWXKLwamYiLhwUHsb5nZHnyZb4=6RrrdUg3CiX7CZOuVime7g@mail.gmail.com>
Subject: Re: [RFC PATCH] ipv6: Use dev_addr in stable-privacy address generation
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        hannes@stressinduktion.org, netdev@vger.kernel.org,
        Lorenzo Colitti <lorenzo@google.com>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 7:45 PM David Miller <davem@davemloft.net> wrote:
> I think the current behavior is intentional in that it's supposed to use
> something that is unchanging even across arbitrary administrator changes
> to the in-use MAC address.

Thank you for your feedback David.

Could you help me understand the use cases where the admin / user
chooses to use MAC address randomization, but still wants an IPv6
link-local address that remains stable across these networks? My
assumption was that the latter would defeat the purpose of the former,
though it's entirely possible that I'm missing something.
