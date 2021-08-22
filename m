Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBF73F40CA
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 20:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhHVSIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 14:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhHVSIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 14:08:41 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87421C061575
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 11:08:00 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id r9so32950687lfn.3
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 11:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=0NKXIgekL60LJdBnISE5iW6+cktRIGjjcRAxPt2OoY0=;
        b=tITGP4xyUawRMmbn24DtWOD3F4MlNBwcvdTtV8CWI6khA24mSfvT276R6Z4JnIFmta
         XufJEKc9gQgKoZPSQJbQR3rKbYKZzrq5wauLWiMLNukBg/MU7ZKRsX+dy295O+dXhz5b
         2sUV1IBxOZF/xEvOQ4VNfrZNeBmREeo7CmGm0vWiJdjRrUPPHsNaUkZZvEcvTUX0uG8U
         81p24qVNTFX9bTBoKi3CiJxhRVoCzEOmPYGGEMJ25UwdnZyCj0t7Ahzsx0+wrCCriONF
         n40VvJJOdOWb4lkPfGWBiWizwipIb/+GDYU8AITfpQLvZN2gdNPEBGYmrbQFNWf3IYbu
         vGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0NKXIgekL60LJdBnISE5iW6+cktRIGjjcRAxPt2OoY0=;
        b=MwV62deTzfHW6leS4JxpMAdbUjFWR41xanckjxcH3OmXrxmbeRZchj+9D6TOShXlIH
         +Vftc98SBIsJAzaiQWLK4XEFEp/FHZ+9vr19A4xaPuJ+WVF9zWu+LGFE0etiY466r7IZ
         hlAbeiqWud/63rGRILAGy+LjeE8EObWdTTpU1fAD91xGQY/yuwR2nJlW1aszx9PBgEkK
         p3gQVAqZKjG9KiCZId7oxlJR4sV3ztT0/IASOz0WVfUFp9RZRIugQ+mYAemb7wFM9/lh
         4WHSR7yNgIY9cdpMypI2mK7CYxeF/REXwwAej9VFMm6D8HlZ2JnOf6E2rgqJyodO5ww/
         ytxQ==
X-Gm-Message-State: AOAM532sRjArUAe0WJO/e29HyUr3PBc5dyBkTLaOQDiP+eaPPMM/Mjaw
        5Cq+sZ3PgaW+7esFGpHP9DS+7c4ggulcCT0Fsw68NG3hnx0=
X-Google-Smtp-Source: ABdhPJw5+MIYP4gYZxmWn1QH+V5hFx6wp2NXk5/7O3f+HviHuHQXwayuSL/KDC222awalnavKgCjRBJEpETaFVuDAW8=
X-Received: by 2002:a19:c112:: with SMTP id r18mr21690865lff.531.1629655678590;
 Sun, 22 Aug 2021 11:07:58 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Mon, 23 Aug 2021 02:07:47 +0800
Message-ID: <CAGnHSEk-gxY3jr-2k8+NSB0uf9H94SDQyxJFVM1LH3A+Bs+5MA@mail.gmail.com>
Subject: Bridged passthru MACVLAN breaks IPv6 multicast?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Normally when a NIC is (directly) enslaved as a bridge port, the NIC
itself does not need to have a IPv6 link-local address configured on
it for IPv6 multicast / NDP to work properly (instead the address can
simply be configured on the bridge like IPv4 addresses).

Yet it appears that if the bridge port is instead a passthru mode
MACVLAN, IPv6 multicast traffics from (the link/"side" of) it cannot
reach the host (as in, cannot even be captured with tcpdump) unless
either the MACVLAN or its underlying link has a/the[1] IPv6 link-local
address configured.

Is it an expected behavior? Or is it a bug?

[1]: In my configuration, the bridge, the bridged passthru MACVLAN and
its underlying link have the same MAC address and hence (at least by
default) their IPv6 link-local addresses are identical.

Regards,
Tom
