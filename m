Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF67DA8F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 04:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfD2C6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 22:58:35 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42685 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfD2C6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 22:58:34 -0400
Received: by mail-ed1-f66.google.com with SMTP id l25so7790985eda.9
        for <netdev@vger.kernel.org>; Sun, 28 Apr 2019 19:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DB8W8g7vI+PLHuaHs4olgEMXQlsvHrhuCGy1sUFXTRs=;
        b=HD0BN8ecOB0cQi08FVXJw7u3TZ0LPuBf87MgOR6npScvbOvblMLBUKplBMUPKhMZCD
         iDYQ2kXO3ajc0fJN/Ue1MNexxlj6JPC9uauSFCA9IroJxSgOME3hr9/317w+ADngwGqC
         WOl2dV2IvkjokGu3dtVerj56X6vNPVlFj/oeZjA8XeeQUJeLV17Opcexy4ECOygiUSbf
         Ce5a/xVo5lU4kIwg9ahlFBNmyIc2wTQN4dMseIvLtikRXAtqRq6bSrUV0yl0YqxztWZo
         qWDX7LznRU8plxuEYW/CW8EeSMBydpWeu/NijbtJNXIxXwFyWVCy9car7b8liSAhGKwy
         QDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DB8W8g7vI+PLHuaHs4olgEMXQlsvHrhuCGy1sUFXTRs=;
        b=BtBIKEMuI0KIPF/0nNGJtR52XeVHYGuh4jliRVi0cVx/49tUCrsG0lvgMO3WfaQvo0
         RNeRVZO/utwwehLBGiM5CgHXIXdE1YxKUIx1crFK4HJg/ygaM/mggfMrMSMD7svq3XgO
         rOaV5dCyBuI4T99u31Owlm6R58Lf2R5LDiTS/PslCaa2sBt05UW2XkTOT1LVFQ27R66a
         aNUPuyun3vLcEWNpnCtq3VH2bSrVIlc6KQ9b9DZzrg7/IwJE1JIKSyERvB2MAaggkn0l
         Te8VlR3PVkypJvAJBbP5Yrba17USQTlD8qXbFWqUEsdp4OUlaf+6WIC+1CQu7PtkZnH3
         SbbA==
X-Gm-Message-State: APjAAAUQVm1C2qmEM3ZFwL7FpRqM2eMAIoR4Nj99VwTHLRqpbLRITK0L
        DL9mYlPb+VZiDdOhmxlYI1O/IbT149/mglTP9QQ=
X-Google-Smtp-Source: APXvYqwVK/yH/VE3pk39dGBNcdPnf9hxG81cA47x3KwXYGqUi/yhD17A5GoGt5debbuSF/dj5m7PWMlGBcYNXVMj9xo=
X-Received: by 2002:a17:906:f29a:: with SMTP id gu26mr7269731ejb.148.1556506713015;
 Sun, 28 Apr 2019 19:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190428054521.GA14504@stephen-mallon> <20190428151938.njy3ip5szwj3vkda@localhost>
In-Reply-To: <20190428151938.njy3ip5szwj3vkda@localhost>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 28 Apr 2019 22:57:57 -0400
Message-ID: <CAF=yD-JLcmyoJ6tq1osgrQbXs6+As0R+J-ofU+XwQWcvaW+LBg@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: Fix updating SOF_TIMESTAMPING_OPT_ID when
 SKBTX_HW_TSTAMP is enabled
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Stephen Mallon <stephen.mallon@sydney.edu.au>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 11:22 AM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Sun, Apr 28, 2019 at 03:45:21PM +1000, Stephen Mallon wrote:
> > Ensure that the unique timestamp identifier is incremented for skb hardware
> > timestamps, not just software timestamps.
>
> Thanks for fixing this.  It has been at the back of my mind for a long
> time, but since I don't use this feature... oh well.
>
> This patch would be a candidate for stable kernels.  Can you please
> add a Fixes: tag?

It is debatable whether this is a fix or a new feature. It extends
SOF_TIMESTAMPING_OPT_ID to hardware timestamps. I don't think this
would be a stable candidate.

More importantly, note that __ip6_append_data has similar logic. For
consistency the two should be updated at the same time.
