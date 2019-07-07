Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56886176C
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 22:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfGGUX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 16:23:59 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39094 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfGGUX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 16:23:59 -0400
Received: by mail-ed1-f68.google.com with SMTP id m10so12669033edv.6
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 13:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fOkgVnrH50pk9BCeUnlqH+zy9Aka8ZHT0XgwB9txUu8=;
        b=DqAz9cE581Kbu/5fHTTt0ts6dlqww4TfLy1YGHHDXBv47xuKNiqg/a3yFKs0tLcT36
         KIIc7XElQB7fw8J8MTLD1v9pfpXD/GN2+JSAzm2guorQTuMR9po4QBypiq5A/mqEvjsD
         Nm8A0Vg4Wyna/2hkfFwLfF3ZdvdFNMZWQ/JMxQMzui4CRlTKOvwvs699yGvTlf/x3N2S
         zv+yPcNu4mRgAqmF/m7bjzXhPRcBZpncBethWkfOZVcH8GniYMuo8hS/c71Ps4J8k4G/
         uR1myyReW/mRGvXLKWyrQkaz5bu3FtD4Ddpa22metvzr5J1eQ9LvVjnwhCbhu6LYVwCs
         bcKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fOkgVnrH50pk9BCeUnlqH+zy9Aka8ZHT0XgwB9txUu8=;
        b=NBtvS1CCkBsWQarYbLnV8LP4KrH4qdaZTOue5z9YlArSX7N1EIE56OzVDcvDq94eME
         6MJdLr6FgCePomlbkASBKXJxpSuuCzxPfQ8xCapNxLgl7l7mi40XKDhgNle0niTyGoQY
         edX3UsAWH5ywO9jKclHLJ60nFhSBc83JgAUDVIjOt5geTJaBl5RcaIKdwVd8qanLSfhq
         aiZQVN0OVdEJVVTsm0eOZUrFY7b7RiiQQoVgdscH9QKnZkYDSw9gk7RxffcD1X9RKwmz
         ho5Zg2PLDDiH86Sw5nynACjj497/qwy7s/KarZAvDOULR5Tfoa3Vw6iKBPoQyMCCKmUO
         LPgg==
X-Gm-Message-State: APjAAAX0ehgKw80kNJgcFG0synWnTWVP08jT6dSvCrhz8QcCtx5I46c/
        TudapoSxfgAyBwyRRnFhCTsk6YRlw5ybWYM2mdk=
X-Google-Smtp-Source: APXvYqyzhJKYcuFEfJLz7iStFkLibxMT8fTJycjidcrSnTCRh/KRmt1gKaocsOh+R5ZJcke0JUJQNGQQ99RGlrJJE/0=
X-Received: by 2002:aa7:c559:: with SMTP id s25mr16282552edr.117.1562531037225;
 Sun, 07 Jul 2019 13:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190707172921.17731-1-olteanv@gmail.com> <20190707172921.17731-3-olteanv@gmail.com>
 <20190707173951.GB21188@lunn.ch>
In-Reply-To: <20190707173951.GB21188@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 7 Jul 2019 23:23:46 +0300
Message-ID: <CA+h21ho1LqPgZOfPjAnKufUBUzC=S4O6jk1TXfQ1ymN_3GFcDg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/6] taprio: Add support for hardware offloading
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Jul 2019 at 20:39, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Jul 07, 2019 at 08:29:17PM +0300, Vladimir Oltean wrote:
> > From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> >
> > This allows taprio to offload the schedule enforcement to capable
> > network cards, resulting in more precise windows and less CPU usage.
> >
> > The important detail here is the difference between the gate_mask in
> > taprio and gate_mask for the network driver. For the driver, each bit
> > in gate_mask references a transmission queue: bit 0 for queue 0, bit 1
> > for queue 1, and so on. This is done so the driver doesn't need to
> > know about traffic classes.
> >
> > Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
>
> Hi Vladimir
>
> Your SOB is also needed here.
>
>      Andrew

Hi Andrew,

I thought I'd added it, but it looks like I edited the patch and then
overwrote it, instead of operating on the git history.
Next time!

-Vladimir
