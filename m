Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C90C2BF6
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 04:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731618AbfJAChq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 22:37:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45378 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfJAChq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 22:37:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id q7so8538722pgi.12
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 19:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XFoFqAUTpn7YwwxBed2kTXk6h/1aI9nA1wnfAvDL7/8=;
        b=dMSHM9kodxoK4diSN84FZAvvz1VlyRyOcKQhvGaRl7G8jWNVxHFSogLHaVnxpfsMqe
         5LcfgNR/r/cpDAGM4QwwC4a8JytTkAfCN0mmQzxXVgcAzKPo0TVXENgDPbxXWFOvOPMu
         B29gxKjn8Uyzmd1MfXX+8dCUzVHg6tfuAZpxcBpSTRGDqElBC1PJvapp7jpyCx2IlP/Z
         vs6YCcWYXEaSoCSpkII1yppdxQRZ7LixCFKYJpnvJAn4B+6Pz+m4p+DXm2iSHO/wlweP
         fhT51UizUfKBBEUlHPDtGATDEMUe4fyKVuJHd8Swlv9TsPDT35oONm0WPh8cBZ/0Gje6
         FDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XFoFqAUTpn7YwwxBed2kTXk6h/1aI9nA1wnfAvDL7/8=;
        b=QWehwFTlPpH8ByVJXPVQM3cBKwpvDYdxxaC/d4xnyD+PGc2DqVunynQ1SP2Y7DD0jC
         KPLwvmAP0FiSSHFt0Kky6e9pkUxW20G0wSYkBZSKioinQ++PsDRL7oOLcLt0fWF6Yznr
         e3WxYAy0KVmy0yV35LjR8aQu8y+BMEGW2Pv+geAFyskxFF/znL9U4KlDcxBr/IfB54NE
         ERchXQmMLopadXuxU3LbOD+IbgRI/iZdaZeojcLnM9bNzumIQRt8vrr2gPxPblJllOSN
         GBtjHXX62cffachNuxF32F7NLGP9xHAp0ekWrwZjXaGp4XbAao17j6I1rlxQoJDHdKa8
         aIrw==
X-Gm-Message-State: APjAAAXLPP7OW6vs3Om6HEdvIZ4pSUiLhrazQ91u9yatgo0NF8QdTyud
        xh7iUkxJdLanDQaMLhTHWPQ=
X-Google-Smtp-Source: APXvYqyI4m8+DDv7migpo4JZ57LUPitsMaI71S+sua8E36RKM+u9fzhlQM6gUlRRxloNK31a90WIPA==
X-Received: by 2002:a63:4762:: with SMTP id w34mr25010145pgk.202.1569897465625;
        Mon, 30 Sep 2019 19:37:45 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b185sm20992503pfg.14.2019.09.30.19.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 19:37:44 -0700 (PDT)
Date:   Mon, 30 Sep 2019 19:37:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp_qoriq: Don't write system time into PHC at boot
Message-ID: <20191001023742.GE1497@localhost>
References: <20190928222228.27493-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190928222228.27493-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 29, 2019 at 01:22:28AM +0300, Vladimir Oltean wrote:
> But I couldn't find a justification to just move the spin_lock_init a
> few lines above, because I don't see why the ptp_qoriq_settime call
> should be done at all at probe time. Writing a CLOCK_REALTIME value into
> a timer that is supposed to track CLOCK_TAI means there will be a 37
> second offset that's going to render it useless for any practical
> purpose.

Rhetorical question:  Is off-by-37 more wrong than 1970?

Some PHC drivers start counting from zero (1970), and some from the
system time (which might be any value at all).  It really doesn't
matter what the initial value is, IMHO, because it will always be
wrong.

> So just remove the ptp_qoriq_settime call and let the clock tick in 1970
> until user space does something about it. Most other PTP drivers do the
> same, except chelsio cxgb4 and maybe a few others.

Not sure about "most".

Please fix the actual bug, the spin lock issue, and don't worry about
changing the initial value.

Thanks,
Richard


