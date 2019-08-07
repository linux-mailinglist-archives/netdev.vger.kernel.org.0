Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9068684445
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfHGGIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:08:19 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:36941 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfHGGIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 02:08:19 -0400
Received: by mail-ot1-f42.google.com with SMTP id s20so34312779otp.4
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 23:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yrj9JfOJiVw9jwMnYzajFxK4IqE05INCCXmJXAPYMEg=;
        b=d96moB3hJkh/z+QtvajPspJgDqFt0QFXhy5T8R0YKXUm4egm7TdN7fVQXJm5m2J08S
         bQJxmEbXKFDjytMWZr9bP2XHQ/ePMJJaCSSaU4rgbvSNv8vSV09Qz5mZb9Q1R+hWW3//
         SiemaQSlN6xcH1GpNm6yyYCUT4C80Ho6h/nixowIDVY6bTGlVjhY/p7gg0Kormz9EH3p
         RoS9j/jyzRbRwSTcON7r6+WYCvozglBkeb4mdhrHbZvutric1v/Vto1/DPia7fvaSU9P
         PXDnPS1BIM1/hzVmsePxB+oQQbqqg1pqD8eXXOAEM3HhNze1kN+RlCYoFC7HthdrwkC3
         Rj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yrj9JfOJiVw9jwMnYzajFxK4IqE05INCCXmJXAPYMEg=;
        b=NIURWQ2o+hT7g9IaeN2h6DtqL2Ix9KrNlkNral5yTG2owVXKbTK31CChQPD6xb5yXE
         mRqDoMllE81QU5Hv3jhSa4o0CGpdHT54oyiWy4S8ZpvBpWVQmqAmvcxfd+Iptn/cwIsy
         yVT5rKP5lR0RG1zlnH4LNClprGtyMSvtbt3mjTPjTzoaJ7HAD0xe7jLwzHhnpwrCfitZ
         i2olSNgwCnyqN5BW8vhlamqST9+BA2smOuzHLuPab2xE0axB1L3ENxWvOaGKt2Q7UDke
         tra78eMvWfgAQpGBi5l49n3a86zG5S5sduhr/J2PZEe6ALBmMEAQhzjTdmIPZWG1UoVn
         BnEA==
X-Gm-Message-State: APjAAAVa/mAABm9iCoGn5FWAGsyCwocpDsRpyAVRjnVGSMKmbmQ9L30f
        phrUAFioGhX2V1Utl0SW241AAAuFCbQvD1v6e0A0hw==
X-Google-Smtp-Source: APXvYqzK3pJgNjkuBeA6FJCM7u+++TPkvntdQQfBTS/fydZpdR7iGIQFemlR0/P0lOiH66cLVhwPo/L4nzxpQTfTyIs=
X-Received: by 2002:a9d:5615:: with SMTP id e21mr7062356oti.152.1565158098645;
 Tue, 06 Aug 2019 23:08:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190805200403.23512-1-jeffrey.t.kirsher@intel.com> <20190806.145104.1044990165298646882.davem@davemloft.net>
In-Reply-To: <20190806.145104.1044990165298646882.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 7 Aug 2019 15:08:07 +0900
Message-ID: <CAMArcTXWBHUpy+p18UJ6RZm2W=vhnLRezste=kHSSv=dyd0kBA@mail.gmail.com>
Subject: Re: [net] ixgbe: fix possible deadlock in ixgbe_service_task()
To:     David Miller <davem@davemloft.net>
Cc:     jeffrey.t.kirsher@intel.com, Netdev <netdev@vger.kernel.org>,
        nhorman@redhat.com, sassmann@redhat.com, andrewx.bowers@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 at 08:36, David Miller <davem@davemloft.net> wrote:
>

Hi David
Thank you for the review!

> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Mon,  5 Aug 2019 13:04:03 -0700
>
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index cbaf712d6529..3386e752e458 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -7898,9 +7898,7 @@ static void ixgbe_service_task(struct work_struct *work)
> >       }
> >       if (ixgbe_check_fw_error(adapter)) {
> >               if (!test_bit(__IXGBE_DOWN, &adapter->state)) {
> > -                     rtnl_lock();
> >                       unregister_netdev(adapter->netdev);
> > -                     rtnl_unlock();
> >               }
>
> Please remove the (now unnecessary) curly braces for this basic block.
>

I will send a v2 patch.
Thank you!

> Thank you.
