Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192D46C1F24
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCTSKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjCTSJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:09:44 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BCD311DC
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:03:43 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a16so8685817pjs.4
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679335417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IHxP/Dy0hoOS/E88SibTDPw0Su1qii3wkO700yRcBHQ=;
        b=QRxPB5972Q0OKI3audRiNPwV92csfovTiAhrNL7BiHJJgBV4wqbRRvBU5WF33r4jI6
         Y+yg+suLDDqL1GD4o9x/IRqZTZuTf5c52mlv4EGTifFzYdGUVvDIk8bzZ3lRdgs+BIPb
         2TQb310mhavYrz86/jpaiKNIqkufodXNfTcT/cMk0DUpgv5zEuC5D45D08VkquL7VdhT
         TKrAYppxiRAnziSGnr/yGxRbKEE7t9UatiCxS0bethUC1od9zlKQJufY20owLDWDW2xH
         Y5mH9SH1lU1dPZvOIlnUCbkcYA5JXhulN4B5nKRf1dIPq38mTKfGcqmYnbJFiz1ur+Ff
         e9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IHxP/Dy0hoOS/E88SibTDPw0Su1qii3wkO700yRcBHQ=;
        b=qgcKyWzLbk9vDBjzbP/vKgnThNinxzQ9fujNUD27Wjr4MyewLIJrqFUQUlubeUzHPr
         ClR+wm/yRjqwmh0j09udSb4PsbRPaFa2kz4eSNgAXisQBxJvFawWOlNfD7BpTt4FJTo9
         OQQuOQUt06VAss/RwdQcxwd9ozDPrk/8eLcbe9OfCE11Xz/Q1avM/FEp8Nw87CnFcpi1
         RYwCf2+eSGtJC05gb3Awx2iS3+nqGoHYaoVmyjw7q7f8KMUG+EYAbG81mPY4USwXvHPN
         mnBfSnbXiZK0jDTTmKNuvHlTZflMvu1YRr5RHV+/R8fZx6riIXQrHEfXnsHckVzVXEA6
         /E/A==
X-Gm-Message-State: AO0yUKWuRZQdmN8VNbDjm7Q8g5kxXCaXEUI5pCxIx/Ub0iS9MBhHLaBK
        ZVHQvVS8oN3RTSebY/v7PiptW3Z4gjbKHMD+3RgD0OSiwbjLFoyaHcA=
X-Google-Smtp-Source: AK7set/UGPi6/bkkYEvnECihGaUiO1dvbuogpuzQNnxj1zWsMI2daVz63CynEJP0iXPAaoI3qjo6tXQ2DfRuewnTBew=
X-Received: by 2002:a17:902:d0d4:b0:19f:3081:db3f with SMTP id
 n20-20020a170902d0d400b0019f3081db3fmr4209631pln.5.1679335416950; Mon, 20 Mar
 2023 11:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230318002340.1306356-1-sdf@google.com> <20230318002340.1306356-4-sdf@google.com>
 <20230317212144.152380b6@kernel.org>
In-Reply-To: <20230317212144.152380b6@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 20 Mar 2023 11:03:24 -0700
Message-ID: <CAKH8qBtaWOOdcfZ2s1Nym6oB1=rC4cxxO6Q5z39yvAyQMgNyAg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] ynl: replace print with NlError
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 9:21=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 17 Mar 2023 17:23:39 -0700 Stanislav Fomichev wrote:
> > Instead of dumping the error on the stdout, make the callee and
> > opportunity to decide what to do with it. This is mostly for the
> > ethtool testing.
>
> > diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
> > index 21c015911803..6c1a59cef957 100644
> > --- a/tools/net/ynl/lib/ynl.py
> > +++ b/tools/net/ynl/lib/ynl.py
> > @@ -67,6 +67,13 @@ from .nlspec import SpecFamily
> >      NLMSGERR_ATTR_MISS_NEST =3D 6
> >
> >
> > +class NlError(Exception):
> > +  def __init__(self, nl_msg):
> > +    self.nl_msg =3D nl_msg
> > +
> > +  def __str__(self):
>
> Why not __repr__ ?

The following:
class A(Exception):
  def __repr__(self):
    return "{{{A}}}"
  def __str__(self):
    return "{{{B}}}"

raise A

Gets me this:
$ python3 tmp.py
Traceback (most recent call last):
  File "/usr/local/google/home/sdf/tmp/tmp.py", line 9, in <module>
    raise A
__main__.A: {{{B}}}


And for this:
class A(Exception):
  def __repr__(self):
    return "{{{A}}}"

raise A

I see:
$ python3 tmp.py
Traceback (most recent call last):
  File "/usr/local/google/home/sdf/tmp/tmp.py", line 7, in <module>
    raise A
__main__.A

It seems that __repr__ is mostly for repr()? And the rest is using
__str__? My pythonic powers are weak, can convert to __repr__ if you
prefer (or understand the difference).



> > +    return f"Netlink error: {os.strerror(-self.nl_msg.error)}\n{self.n=
l_msg}"
> > +
>
> nit: double new line here
>
> >  class NlAttr:
> >      def __init__(self, raw, offset):
> >          self._len, self._type =3D struct.unpack("HH", raw[offset:offse=
t + 4])
> > @@ -495,9 +502,7 @@ genl_family_name_to_id =3D None
> >                      self._decode_extack(msg, op.attr_set, nl_msg.extac=
k)
> >
> >                  if nl_msg.error:
> > -                    print("Netlink error:", os.strerror(-nl_msg.error)=
)
> > -                    print(nl_msg)
> > -                    return
> > +                    raise NlError(nl_msg)
> >                  if nl_msg.done:
> >                      if nl_msg.extack:
> >                          print("Netlink warning:")
>
