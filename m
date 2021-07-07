Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9463BE8F8
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhGGNrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbhGGNrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:47:17 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7736EC061574;
        Wed,  7 Jul 2021 06:44:37 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso4284941wmh.4;
        Wed, 07 Jul 2021 06:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7HoO777ODl3CaYhM0dKd5nY0hn/FqfWTEQuvzzyL5K0=;
        b=vMEH+TFKvFv524Mvb6LIH7+r0dXmVCqSM9ni5Odv22fm2w/TY8evb2mmBlfnZu0hIE
         MrKIEomkLj1KqlOqRTzE9cw+C+kpIXXSvcxsdMauOmQoZ55WjG0Nx0vJ2dCIO/pv2QpD
         67qoovHdnjZCMIgoAOqL9Bjoqt7Bx+Tgd13c8Rzu09ZTAv2MA+iCvo6Ug2mI76a4uxQ9
         5P2zhqVJ/o7AnvvAZa0cGfriN1iuHkkw+av8rSfuBxi9wA3Q2fGlAQrWlXqzvhtij2wC
         zNVJdiE4la1rHrJQCKJGhp+K99VYQ3715NnQeF/jqxVL02s2Z4LUB60OjjcXVBofOJrU
         pcxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HoO777ODl3CaYhM0dKd5nY0hn/FqfWTEQuvzzyL5K0=;
        b=p00qur0V2ZZkgfRpJFUZ0A06mb8M6OdTIBmzrmLbJcylUWvn4wW80nm/X8sQpho5Oe
         sHTsY1NwYguLI22iXPzbe/opB3jrPgEBkx3MlhGoONViepKPCZ/GmmMOvK7QqlAXTT78
         M/MkrAEgDYmLUQqOo37f/yBkXT8PRbEpXz0Q+DQGft68ki4rDoj3bCaOXJ1/XZAPknH0
         9zL4uhWEd61HG1yIqcTpdgqVQpcrdESyyspeOgYOwLDD4HcQFyM9gYUL65e2Te6kQLNX
         GJEQLGIfNXXhn0FU4dzJMgR1Pv2d96BG2DY4tUH3giLKYoNICy+Uio8QBNc+9FUeI2bj
         j3ng==
X-Gm-Message-State: AOAM530w6kEcewpeG7nGgQ34ZOffM8TcNz3hmp6nNBri4UtxcBTgTV9o
        kKjWhbayihr8IHPCcwHHuVNxbaQs49R/IALeVeojLU1Kbg4=
X-Google-Smtp-Source: ABdhPJybEHc60axCSGk8qJoZ9ObsYO7vYHlSTJsV0EeT2/xVrIaeYzUNBujqkd5EBYolgdKc2PHdXw3Jy5DOcZ8p/Vs=
X-Received: by 2002:a1c:e485:: with SMTP id b127mr2502161wmh.91.1625665476160;
 Wed, 07 Jul 2021 06:44:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210705131321.217111-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210705131321.217111-1-mudongliangabcd@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 7 Jul 2021 09:44:25 -0400
Message-ID: <CAB_54W5ceXFPaYGs0T4pVq8AzRqUSvaBDWdBjvRurBYyihqfVg@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 5 Jul 2021 at 09:13, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE,
> MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID and MAC802154_HWSIM_EDGE_ATTR_LQI
> must be present to fix GPF.
>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks, but there are more places than this one. Can you send patches
for them as well? Thanks! :)

- Alex
