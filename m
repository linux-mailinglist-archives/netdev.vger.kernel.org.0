Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6602B1BAA50
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 18:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgD0Qrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 12:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgD0Qrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 12:47:51 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43C7C03C1A7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 09:47:50 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u15so18342494ljd.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 09:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mhCQLPtNjO6YHuKhouClWrqU42WmpvfpWOGCAYEqbv4=;
        b=O0vxByP4X+/3CDU23KXHqB01x8ZguuOJkPTkNzYnLJOxPXOOG0xtMTuFy/SwRNSg52
         4OUJRFH2vG2o5C3qhqWo6xj9pJqtFw4d7tX+bVp1dF3INPAdZCmAco2FLAbro0BvwcMA
         RxwJT9LNancTdo6ZNHxMOJNEsoGxIEKRAH3CZ4aRFnG1v3WVdA+C/vAArdg7KqaiEiGI
         l1+qGf+9GIt8J71dclf24+1lZ5NE+ksDt8+eVUoiwk36InXoB+H0ycS6bfscSgm2Rqi9
         UA1SFJ47sI+VDsYDAhNQxOd/PUNRSRgKXHpnQRzjBAiiE4HeG9OUeWummJulUJpIjhCg
         Tm2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mhCQLPtNjO6YHuKhouClWrqU42WmpvfpWOGCAYEqbv4=;
        b=Z5zzMf8v8Z+3GCMvyBI6gcbKmNkVXk5vXv28j7jhE9b38AeqoTNegr9spZCNhhqWau
         flfWLCval+ueuG+0XLMMSWOQXSn/qcHJbEn3Swor8jQCBh/8v/gYUR/eSQK9qcQm0Zs5
         QhiBNGu11BkTdh3msHmgCtYmMNn4Jdh0LFCv9QFVJzhrtp+h4hVvsGvT972gljjerEFT
         9WWZhwKdVNI4Xxwzqt5RJs3DtNPohlBEootJrrKG/O1LYNDvb6MqN4DokyRenQYMTiRx
         LBF87qUG7uvfAQ23Nblni6x+9DKRP2dXOjuqUenqAmThCuMKyVoi15s8Q4rYdmYy/nMd
         cRjg==
X-Gm-Message-State: AGi0PuZfRwnIww8A6neICUGgFe70+LZbEm6+pdyq90QqnoHRMtqBTgiB
        Hcx6C3xL+MKmbHnvhjjKfRefR6/vG1Ji+w/BMns=
X-Google-Smtp-Source: APiQypIBi9LGxqJksGsjgBblD4SQ8vfEz4Mi/3qJzWZz3RgzxTlwCJbZPtOjFf5ScIE6PkmK5ItfMOh5OWK/esf2SJw=
X-Received: by 2002:a2e:9bc4:: with SMTP id w4mr15626472ljj.178.1588006069283;
 Mon, 27 Apr 2020 09:47:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200414004551.607503-1-andrew@lunn.ch> <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427163703.GC1250287@lunn.ch>
In-Reply-To: <20200427163703.GC1250287@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 27 Apr 2020 13:48:38 -0300
Message-ID: <CAOMZO5BxmDc26fw0nzXJ4Obp0NDka1odFwVds04xYkV2O7UKTQ@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Apr 27, 2020 at 1:44 PM Andrew Lunn <andrew@lunn.ch> wrote:

> You PHY is an ATH8031? If i'm reading these IDs correctly?

Yes, the imx8mm-evk has an AR8031.
