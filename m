Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147FA17871F
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 01:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgCDAms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 19:42:48 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40580 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgCDAms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 19:42:48 -0500
Received: by mail-lf1-f66.google.com with SMTP id p5so7835lfc.7;
        Tue, 03 Mar 2020 16:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p37AmYrcEaUmAdk2JpsrGtIIoJlVrnXD9L/48H7szRQ=;
        b=rhbFu6Aclm0dQJ92oSOFQLPq7/dTdxEpt0sMgzqSe4xHQ/CmfgsqnMXoEBTVpHu/aF
         HH8hqfEMAxKG+lxOOb0n07YcA48JqKK7SXZns78kwLwgHXxhSsX3RQT7JPTsRHrj83nN
         XaLcx+sHXGE52KILWPJTIg+s7iffAAv97w4T9uxtom2FRzfDjyjScnPImrTRpNm9p2DZ
         0RIsbPvdOdM+spCra89MM8ZSvvWhCjcZQq4iipsNPrGivdoOXBClrDZpGQvX+EWy/Qb3
         E0PB8l8RflVu6sIRr2NBc9OCD9iywFcmI3Rzu9qX3RHW0U9bymKOBwtVZGBLrSwiz+qY
         Ckrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p37AmYrcEaUmAdk2JpsrGtIIoJlVrnXD9L/48H7szRQ=;
        b=Ct+CxxE45N1n3xOPxbKeWALxVS4XhU7a+XfQYd6i5JFplOYBE1AK/CyXxbiO9DQ71y
         DIfj6KLA0fxTYgB4assEO3zgg8vPtDaNGo4ma3KrKSeS3nWpbt/+TDYZ67Dm1mMW3khC
         XL41QPXw/nu1cLFyi+kj7xI5Mruqi0iIDSUBfyuptkDHuU2qti4CpJVlnPQWFrXNEIcA
         fQ4AobSFejxwhRZKUZVOV1rIAod0EEDrpFKkI8p+u6OxHTHo3vG0EDEUqlw2X+PL27oH
         mxgQPDVLyIH+VhkSYwxQbDMd7ufaLusfswXSWDE8R/KpZtvoi8d9jqkAAKVuqyPl5Gtd
         EUWQ==
X-Gm-Message-State: ANhLgQ1+qjxsH6/6PYW9G258kL9SJeG89Li+vFiRCiGolf7eyBkcGUDi
        Dq2tdb/tkhungGXZbttT1bRQFPwZz41Tp12X8sk=
X-Google-Smtp-Source: ADFU+vszYebjffzDoRvj8YIgxx4Mxn0KStNsIcZieqEjUkcHOzOvZVal+MB4yaGEZ0NhXxyGmdyT1FCEzQgnlq6SHXI=
X-Received: by 2002:ac2:5df9:: with SMTP id z25mr334928lfq.8.1583282566156;
 Tue, 03 Mar 2020 16:42:46 -0800 (PST)
MIME-Version: 1.0
References: <20200303180800.3303471-1-andriin@fb.com>
In-Reply-To: <20200303180800.3303471-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 Mar 2020 16:42:34 -0800
Message-ID: <CAADnVQ+6xhGRj=SRPXTx9XoNHaJ4Uut0DCQ4=wLa7G8b9j4_ow@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix handling of optional field_name in btf_dump__emit_type_decl
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 10:13 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Internal functions, used by btf_dump__emit_type_decl(), assume field_name is
> never going to be NULL. Ensure it's always the case.
>
> Fixes: 9f81654eebe8 ("libbpf: Expose BTF-to-C type declaration emitting API")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
