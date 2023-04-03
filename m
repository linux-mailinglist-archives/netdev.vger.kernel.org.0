Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BD36D45F1
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjDCNhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjDCNhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:37:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE4626A9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680529028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqVGEYwOHd6PhdUY1FDcopFk+fgKL+rug15aKzHniyw=;
        b=WuXO85+RRAV6ikMf7ib0p/queaTpBoXL4OoZ/Km7Q3TFArENokPDU6htxBP4IGu1OuDkZP
        uegDN2ozW2iyKJz+ddG4DEqWxvSZj3bzS0r01YLLeptYSqqumDQNsO7275Hu9FiT3Jg6zB
        xEpOE+9rzD11xtZmly0/XxquTs9sHU4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-b_yNud1bPBK483ZOM9ByBw-1; Mon, 03 Apr 2023 09:37:05 -0400
X-MC-Unique: b_yNud1bPBK483ZOM9ByBw-1
Received: by mail-ed1-f69.google.com with SMTP id i22-20020a05640242d600b004f5962985f4so41855261edc.12
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 06:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqVGEYwOHd6PhdUY1FDcopFk+fgKL+rug15aKzHniyw=;
        b=gHMBtH/euz+KAU7d/qB0yQUjU+i1C+DRbzJAZZChNiJZt8mKwPJ6frMOkmnu94w+kW
         +c4kgDTcbAYxlMSWg6lS31eszY5c4YFKUl37ai0c34m62+V1IjslnGkpcS5g+zwDtkNZ
         uKdU5oA+0jmzt51Li5rBdVpBcDg4ualEA0vy21i6QTHusoJpUwjWGgvDT1SWTVMfthKK
         KP5XvNilsnoGgneOPuUNSQB7Bwk6NrzcaqU6otozDt7Ou/D9XjRjuUtHgNLePF1vfEZb
         mvqFW9oDDZxfgHyFQ2gWwiKOn1iTWFxishFnYArYrzqg43SlyjattQk2MbWdVYgNUpsn
         jePA==
X-Gm-Message-State: AAQBX9f8y/3RUIhl1eHMTJ2O2L9hPsNqyXvde1b/8I+OUFsJsduK1Ltl
        dRIzR8xICBEMAl+Iv+OYGy/JbSXw55iggjttoLLcSOHEkHT5G9EofhKd3WmruGqS0BwSLYA61+7
        c30j/76Ike6YFf9QsJxkzt9RHZxkqeX6s
X-Received: by 2002:a17:906:ee8b:b0:93e:739f:b0b8 with SMTP id wt11-20020a170906ee8b00b0093e739fb0b8mr16254810ejb.3.1680529023918;
        Mon, 03 Apr 2023 06:37:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350b5/Bec/crBjlO6IL7EBuXgg8MSv3NWM+r4IdSoORQwjc+yIysiRXsIHyYHsw5FOV7c609mBFyk47tURnc5cBU=
X-Received: by 2002:a17:906:ee8b:b0:93e:739f:b0b8 with SMTP id
 wt11-20020a170906ee8b00b0093e739fb0b8mr16254795ejb.3.1680529023686; Mon, 03
 Apr 2023 06:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230401172659.38508-1-mschmidt@redhat.com> <20230401172659.38508-2-mschmidt@redhat.com>
 <d8de0d9c-6ccb-4fce-a954-177e6603cb46@lunn.ch>
In-Reply-To: <d8de0d9c-6ccb-4fce-a954-177e6603cb46@lunn.ch>
From:   Michal Schmidt <mschmidt@redhat.com>
Date:   Mon, 3 Apr 2023 15:36:52 +0200
Message-ID: <CADEbmW0knbPw7R5_Z+GYs2-QkEP4tU4iXw6RtsnXvAFxJZ4GRg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] ice: lower CPU usage of the GNSS read thread
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Petr Oros <poros@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 1, 2023 at 8:31=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Apr 01, 2023 at 07:26:56PM +0200, Michal Schmidt wrote:
> > The ice-gnss-<dev_name> kernel thread, which reads data from the u-blox
> > GNSS module, keep a CPU core almost 100% busy. The main reason is that
> > it busy-waits for data to become available.
>
> Hi Michal
>
> Please could you change the patch subject. Maybe something like "Do
> not busy wait in read" That gives a better idea what the patch does.

And I thought I was doing so well with the subjects :)
OK, I will change it.
Before resending, I would like to get a comment from Intel about that
special 0.1 s interval. If it turns out it is not necessary, I would
simplify the patch further.

Thanks!
Michal

