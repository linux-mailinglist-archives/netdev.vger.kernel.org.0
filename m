Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3426884C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 11:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgINJ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 05:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgINJ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 05:29:35 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38020C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 02:29:34 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u126so17116838oif.13
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 02:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ENRlH9SbIRX5bEXHWy1oBRXo8Zx79qj9eLQnj+2tS0I=;
        b=r1IIjpbydmwAZZdeYqAI7aP2BNIb/kmwErZJu1VSq9ShVpWidZYL7JjmmrsAbEInsJ
         GhgZAWWG6ucK6jXWj1a66Tglkl4A4GWCBy0wz1C/HFVmSPKXn2j/U8rGGzxGh8N7zunQ
         +KvNEvB8RXw98Z352SF2Y8ttbxTcFRGiYG90o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ENRlH9SbIRX5bEXHWy1oBRXo8Zx79qj9eLQnj+2tS0I=;
        b=evGdvyvBPSc8BDmP1L1pNdzIwnKHHbjuc9NcucFXeQqTed5DcSnKF6NT6QCDGcPlcl
         u4IRJaplfo667lRQjUmb4bnu+7JyVFH4VH80kJV/L0lpORNOzdw5/9JZfuwdWqguUv97
         mB/1QHpYF/NWte5lImUEyx1kW7G3zP77ldLvBQ1f8K3OIvepBePFg5WsU5Om7MT//pLD
         EPX+BeMeflGJHamRUHDgmA7s2eO0BcxPUJS/vDYAZGBRPLEx7hPSK5yQAfTDX9Tevdg1
         6aMMare/4nNIQV46miW8mbMil/BHa4+AZkaI/cDs/sLOOKLJI5lNLqw7JvtsN1ld+zXf
         fgMA==
X-Gm-Message-State: AOAM532+1rDIpDDvtlMCQBoUHEQZsPI/R7vkhdhNsx9j8eSFFEljetO2
        +DcSX58VoJ0TzvWhCcjqHpWtMPLoNz1JhoK9qTFrd5S7SAs=
X-Google-Smtp-Source: ABdhPJyGOwkRJXXboyKZTX7ep3/ab9oGhkvFJrtlBSBxIq0A6lMkDnkiGbq5WN2HmiT/sB17TFjLbMK0It9bCOF06NY=
X-Received: by 2002:aca:f0a:: with SMTP id 10mr8386685oip.13.1600075773692;
 Mon, 14 Sep 2020 02:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200912045917.2992578-1-kafai@fb.com> <20200912045924.2992997-1-kafai@fb.com>
In-Reply-To: <20200912045924.2992997-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 14 Sep 2020 10:29:22 +0100
Message-ID: <CACAyw99zWUfZnDsr3bFPatBOdEg75cWh7rSp_M4OQ1tM7mTTyA@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/2] bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Sep 2020 at 05:59, Martin KaFai Lau <kafai@fb.com> wrote:
>
> check_reg_type() checks whether a reg can be used as an arg of a
> func_proto.  For PTR_TO_BTF_ID, the check is actually not
> completely done until the reg->btf_id is pointing to a
> kernel struct that is acceptable by the func_proto.
>
> Thus, this patch moves the btf_id check into check_reg_type().
> The compatible_reg_types[] usage is localized in check_reg_type()
> now which I found it easier to reason in the next patch.
>
> The "if (!btf_id) verbose(...); " is removed for now since it won't
> happen.  It will be added back in the next patch with new error log
> specific to mis-configured compatible_reg_types[].

This is a nice idea, thanks.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
