Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6889C82755
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 00:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbfHEWJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 18:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbfHEWJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 18:09:56 -0400
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABAF7216B7;
        Mon,  5 Aug 2019 22:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565042995;
        bh=NAJ16jvh/qchypdVowjtbzNr9+9foVnE+vd1uUZQC7g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UdlsxMT9wxnPg84czTc53XMAznVmd7n8JRcYPxB0Fu7FGgY6Vf9s/Dqc+UR+3IfO7
         LPXWB3QDqCrtcNwuUxU7BaE/2hGz/E0e0XBJLo7Q5km8dkVP/ybkS82B3bEJoI21rs
         XBRKjIh4YtimZeQp5Or12nvID6o1ifjlu7V5KIpU=
Received: by mail-qt1-f171.google.com with SMTP id d23so82619847qto.2;
        Mon, 05 Aug 2019 15:09:55 -0700 (PDT)
X-Gm-Message-State: APjAAAWqtpm+nZDV1X2usZAWszPpM5jNCK8vVpVFS+yAzUgDQEYw9RYl
        F6gFcCeQV7+EArf6caBFN7RBLQCEdkWMKIzgpg==
X-Google-Smtp-Source: APXvYqzN7Oaow/mdIokjxZIROhfoq29oWOHhIQUUHynApmz52dA7L6a16lTZR93u1Os4RUyoD7Omw1XiDFtlZBNZ4Fw=
X-Received: by 2002:a0c:acef:: with SMTP id n44mr215262qvc.39.1565042994893;
 Mon, 05 Aug 2019 15:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190805122558.5130-1-narmstrong@baylibre.com>
In-Reply-To: <20190805122558.5130-1-narmstrong@baylibre.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 5 Aug 2019 16:09:43 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+efvvb1UK-Nas0G5XefLWwN7ebnqoevi+W=jj4r3E2dg@mail.gmail.com>
Message-ID: <CAL_Jsq+efvvb1UK-Nas0G5XefLWwN7ebnqoevi+W=jj4r3E2dg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: meson-dwmac: convert to yaml
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 6:26 AM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> Now that we have the DT validation in place, let's convert the device tree
> bindings for the Synopsys DWMAC Glue for Amlogic SoCs over to a YAML schemas.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
> Rob,
>
> I keep getting :
> .../devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: reg: [[3376480256, 65536], [3364046144, 8]] is too long

Because snps,dwmac.yaml has:

  reg:
    maxItems: 1

The schemas are applied separately and all have to be valid. You'll
need to change snps,dwmac.yaml to:

reg:
  minItems: 1
  maxItems: 2


The schema error messages leave something to be desired. I wish the
error messages said which schema is throwing the error.

> for the example DT
>
> and for the board DT :
> ../amlogic/meson-gxl-s905x-libretech-cc.dt.yaml: ethernet@c9410000: reg: [[0, 3376480256, 0, 65536, 0, 3364046144, 0, 4]] is too short
> ../amlogic/meson-gxl-s905x-nexbox-a95x.dt.yaml: soc: ethernet@c9410000:reg:0: [0, 3376480256, 0, 65536, 0, 3364046144, 0, 4] is too long
>
> and I don't know how to get rid of it.

The first issue is the same as the above. The 2nd issue is the use of
<> in dts files becomes stricter with the schema. Each entry in an
array needs to be bracketed:

reg = <0x0 0xc9410000 0x0 0x10000>,
          <0x0 0xc8834540 0x0 0x4>;

Rob
