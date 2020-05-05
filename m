Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06171C4B18
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgEEAhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgEEAhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 20:37:31 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944EBC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 17:37:31 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i16so643384ils.12
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 17:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nyo5f9Qq31++/Cmz7YV5UF6JwbKTiJfSZJgOsFNhUuI=;
        b=LslhQ7n+FPlwKhJgYj1yGILN30+p9DJFjdsBFaY7cbYBpc6EHZ8/vOoXtHvmXBZaZ3
         AW/d5q5MumkSn7H8ypxvpL6aubNE48KHGNY4Sa99hXENVzkm0wHrlfYPWxggLUjigKlU
         PJt1fFEEHEEzvBGdRlPLTw+TQL/Iu9bGNRuGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nyo5f9Qq31++/Cmz7YV5UF6JwbKTiJfSZJgOsFNhUuI=;
        b=N0vbr0ySI8ILXq/Ma7s2+VsTYDtxAoDo7CBEu9SrSqbCmnI6TUWhSfGIOI4JZj0qXq
         mccU+HmjYKdWLYZpepbdzadlB4FozzqIHON1fkmZv1ahLDXTOs7Hmy6Nr8bePFJzwui7
         mYwJ/nygKu2n3WC+ds8B5CDlmfvRsM3OduPkRSBK18pDYN3pzsMqi+6Oil0PyaC7Uidx
         yp1xFI8hiMSqOK+VxrrJoJFp3KWDTep7H10dLRqdTf1o9xlRkvHTcwR2stH8W6U/WXtb
         A6OH5oZAWkcx+zaw14cikanBoJni7S8PLCSH0umFxQpge0hjAxcumaMwrQb90KDNsGig
         vpdw==
X-Gm-Message-State: AGi0PuZNaiTaavLRk7kLs0Y9WcUIu2wIw77TMKo2qvuJiWDfAzjMefgX
        bH/RuLpssWJ9lkxe3yCpMhy4o+YojPTevd0iihtE3g==
X-Google-Smtp-Source: APiQypJwQjEkLEW2QIeoqPm9YUrb9L3WNzAzMZLane/JVBtxjg3N5Q7xrAwWlpSvARVT/vQCTRu2lvnxr8Kmmf/5CyQ=
X-Received: by 2002:a92:c527:: with SMTP id m7mr1235838ili.39.1588639050138;
 Mon, 04 May 2020 17:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
 <20200505003035.GA8437@nuc8i5>
In-Reply-To: <20200505003035.GA8437@nuc8i5>
From:   Jonathan Richardson <jonathan.richardson@broadcom.com>
Date:   Mon, 4 May 2020 17:37:18 -0700
Message-ID: <CAHrpVsU5LO8P74r=9hmfFcoX_zLc8fYAQxmV8J0THbM6OJWfyQ@mail.gmail.com>
Subject: Re: bgmac-enet driver broken in 5.7
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     davem@davemloft.net, Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 5:30 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
>
> On Mon, May 04, 2020 at 12:32:55PM -0700, Jonathan Richardson wrote:
> > Hi,
> >
> > Commit d7a5502b0bb8b (net: broadcom: convert to
> > devm_platform_ioremap_resource_byname()) broke the bgmac-enet driver.
> > probe fails with -22. idm_base and nicpm_base were optional. Now they
> > are mandatory. Our upstream dtb doesn't have them defined. I'm not
> > clear on why this change was made. Can it be reverted?
> >
> Jon, I am so sorry for that, I will submit a cl to reverted it to make
> idm_base and nicpm_base as optional. sorry!

No problem. I'll let you submit the fix then. Thanks for taking care of it.
