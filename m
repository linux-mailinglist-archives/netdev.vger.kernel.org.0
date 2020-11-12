Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CAF2B119C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgKLWfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgKLWfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:35:15 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857F9C0613D1;
        Thu, 12 Nov 2020 14:35:15 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f20so10438903ejz.4;
        Thu, 12 Nov 2020 14:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p57BL1UoJnRDA8LQQBCOb1AWL61sYpqhOcXl2s2Ktmo=;
        b=QGeT47vbxx1u+X8AVugaKGDgMjeIGjP3nroq6qHJYc4hHBT7RrAQu5F1RNHqOxW+Ph
         t9GeGsMzalx44u+Q/lISz/mgFTv29drub/WRetCfj8svZ865OZB42+3Jvebt8WQfqQ/a
         WMYnz+gA92yYyFsBA9Yc7Y7Bpxt4nd/WOU5CXICc8odukDbrHeAVr0ieajz2pi6j7RTp
         n+NaIW9Yx4fSufYqVYhbzdnbNwJlzbEmIeDwJMPfH2sBDxZ09hIjOsnE9M5t/HLJ0kfl
         necRCubK5FCjxz0CAnBIR04wBXOvazPf0WFDMneI6SwF845XOcii8aJ0D+oyAZhcwymh
         HM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p57BL1UoJnRDA8LQQBCOb1AWL61sYpqhOcXl2s2Ktmo=;
        b=MRJsfk5wh0wkcbLk7c0uDP72rhkKvSrUFyBn52kYuro0L6R52/nsc/+LmGQU0T57kk
         EAYFQ3k30n9bB9cvujDS8J9gy8H8Oifm+xOICCiopgR8nq9FF6Fot85UdQiaBi7hJ9xr
         /w72D0VpvapyVaL16klrIjcn7vtBpr+gAK/Sq3PeHEr2PMhwGy/RdbW7ZqLShTuyWB6Y
         sjTQf2qP7OnzArkfSJQ14qmPfCY9TI/ZX6gh3xqr9DUPXOAL1FkBojfrR+Ulabfebatp
         guHA0gtgiJT1FegfPsQUBx3qvKiug6675LZWoUBGRpbXgieIRlannAdnVFMPmQ2lR0/4
         PJaA==
X-Gm-Message-State: AOAM530NvVgNhgv6xntoLTZANPaXAx9jBI5lkbDa0Ge5nrmuLMNy+7HZ
        RdJkFjuaa7gyBB6lQ7KumHk=
X-Google-Smtp-Source: ABdhPJxSbE3Jwqg8xMBq220twIqtrWBS6+9ZlX9IX162gQ1ALtJ2lVuifaNmfGfuocLV9VyC1u5dNA==
X-Received: by 2002:a17:906:5017:: with SMTP id s23mr1581466ejj.359.1605220514250;
        Thu, 12 Nov 2020 14:35:14 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id g25sm2606855ejh.61.2020.11.12.14.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 14:35:13 -0800 (PST)
Date:   Fri, 13 Nov 2020 00:35:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/11] dt-bindings: net: dsa: convert ksz
 bindings document to yaml
Message-ID: <20201112223512.g77usyxfmsisklgp@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-2-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:27PM +0100, Christian Eggers wrote:
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> new file mode 100644
> index 000000000000..431ca5c498a8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> @@ -0,0 +1,150 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause

Where is the "GPL-2.0-only OR BSD-2-Clause" license coming from? I see
that the Microchip KSZ driver is GPL-2.0, and the previous bindings
document had no license, which would also make it implicitly GPL I
believe.
