Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C3412AF84
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfLZXGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:06:20 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43403 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfLZXGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:06:20 -0500
Received: by mail-ot1-f65.google.com with SMTP id p8so34024837oth.10
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 15:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pmmPiTac3WeEQtt7IFL8QKaw6tXi/ITHfOgpw/sJNsg=;
        b=Q40ymyeQHuUN6QO93+vjqvyznK8l9vFNp3myN+siAdRSyINO8hQowtYqbrn8BxnTjh
         k10kgaX122zDjlyiKTfr5wDEMvxpFjEjzTqhdDkmcP84iBxm7oPzCMXq6TVBGR+3U4Ke
         M04xcEJJYfI05G0yAJGnC4yJy2rA6NX9wap/8cYDU1cPY6QgSML1UpDF431HpdzcBoCR
         pEi2+dNdAjt/D6Qr75r7MD4XBdWmotuKZZL/h5sKkGI6sSRGet+SrEkJ0OLxmiMsQMKM
         TU2IbiyFUtn1+cNtcLaVvfOVtU0ww+0K9lOwh7Tcsqnfh15S3vQcNbSWtdlKnrmdgHkr
         679g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pmmPiTac3WeEQtt7IFL8QKaw6tXi/ITHfOgpw/sJNsg=;
        b=gzOiA5FKR0u1tCmliA0+AJxFixZGNjDQ/Toe4R9Ei0gXKs9sNLjqvYU78+q5b+UQmZ
         FDDZQpVka/mtYzUVmE7afUKuH4Wd9JhptOeVrM4wXVRtYY9hWRYkdCC3g7gx1paeppMz
         UNxI7VgUYEvjJYKAGV2DHc5ZkdHvvnc5sRdCBkFJLpDDu1lpU1K4IE6HAH2gXYkHOVUS
         WXU147nFO2Qsoz+AdiEiuGv0AklVpllIKAwq67ClEhT5K9QjQ+rL/7nxRQMLG9jgWiXS
         BlNA8BMcnWeaMX3TUDzxip6E/PIQQwoMP8TEcO5Tbm8U1+xO3nc0kCO9VhSG/syfByUh
         ZcrQ==
X-Gm-Message-State: APjAAAU2Boix0+P5/jeHKUWvDDWii89fnPFMtlUW4xsUfvWP7XS3wytP
        vtP9W6sMrNBsCU/c9xryxebimVD2I1Z65d4U/0z3Aw==
X-Google-Smtp-Source: APXvYqx66QuXIfpF90Jptuw+jqrpHZPZMHCKW5M5BYmMXFWZ4wSZNfDvRZnrMSaDBBf3oSGcTbDE/1bC7TA5E1657a4=
X-Received: by 2002:a9d:4c94:: with SMTP id m20mr50126037otf.341.1577401578841;
 Thu, 26 Dec 2019 15:06:18 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-3-edumazet@google.com>
In-Reply-To: <20191223202754.127546-3-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 26 Dec 2019 18:06:02 -0500
Message-ID: <CADVnQy=1nYJVTC_Qh70oVSFPGSahwHoUNR17NOtRAiz7J38afQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/5] tcp_cubic: remove one conditional from hystart_update()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 3:28 PM Eric Dumazet <edumazet@google.com> wrote:
>
> If we initialize ca->curr_rtt to ~0U, we do not need to test
> for zero value in hystart_update()
>
> We only read ca->curr_rtt if at least HYSTART_MIN_SAMPLES have
> been processed, and thus ca->curr_rtt will have a sane value.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
