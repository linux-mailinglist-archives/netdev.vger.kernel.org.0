Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED41B158D29
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 12:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgBKLEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 06:04:36 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45406 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbgBKLEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 06:04:35 -0500
Received: by mail-oi1-f193.google.com with SMTP id v19so12361989oic.12;
        Tue, 11 Feb 2020 03:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QijJK15dIuRzW40NdnOBenGU/zvgd3ESluIZX8bbPoA=;
        b=KgNc/h5ARV+DaU+Na3hHmktyVZfA9T01RIwwCkl732spGIg6MTlUlQ3XwzMDXq+GbP
         EpOGhCQr/fHhhsIg3LoNTfThGTwKwoZAwG/Pd/1MNT5wxaylHrGEZ3G7pAK9u9ucKfBb
         da+5bke8uus7sb6hR/5hLJLVlnU085xQmvC+K7juC3e0BthBZRGfYVnds+/xMfkCAqOd
         vNDD4FlQA8IXS9XiclDABsz8nOFQIQGgidaESYp/X+UeE5ujKjOBq2exktvI+NpgON5s
         aGVrNE+TpfAZ7qglGQJZldTQqWxyd8FqbVl7a2LkKwylx/vvq+xg4LL2VdZWIc9C2E0A
         iP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QijJK15dIuRzW40NdnOBenGU/zvgd3ESluIZX8bbPoA=;
        b=jKmlmBqEN2MuZD0r9RvbDHqAocJXGe89auSj6mqfL7blF2Ku4FNpWda/9o0GQo2xNQ
         Gp5wVDXrU491Gv0SRUA60A6/gUE3r3xn2WA/DBA3xrANICxpUq2f4i6oPeB6W25tJl68
         rcU/rW7UGDb4/iJFK7IEm7z4PuyVodtFAOGJPKbLmNB9Z2r+Jp0ni0pCSPbQD1TZitWU
         mAFwO7XmChDr/LhnR40H2rPWlUc0h/OpVcb3Hqy7a4tsxokCceczIEEE1l31Ppc8tAwR
         /1LlV8ntnAa8xq97oAIragij755Nt1dz4E+mw05/yz+6IRrImJSs8slCCZdBQc/pJ3rs
         O7DA==
X-Gm-Message-State: APjAAAUI8oe6Z75dzkK+/TPdaEJnMxxAY63+F9j4tmgjw+Y+AArc5bBZ
        anIMUF+Fz//NVSQSLZETqrNdnBzYzTG4RUOQfTk=
X-Google-Smtp-Source: APXvYqw5c/xwE46KzdbN72xhUuGVm5XfBn8rCv+kNONWwVvTX5RdyxoYEgNmx6SDA704Vq4vZ66IFsZQmt7zRhOevNE=
X-Received: by 2002:a54:4791:: with SMTP id o17mr2367280oic.70.1581419074785;
 Tue, 11 Feb 2020 03:04:34 -0800 (PST)
MIME-Version: 1.0
References: <20200208155504.30243-1-bjorn@mork.no>
In-Reply-To: <20200208155504.30243-1-bjorn@mork.no>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Tue, 11 Feb 2020 12:04:23 +0100
Message-ID: <CAKfDRXg0KyJpO+PgPT++DYS8C-ypMd3fpcoLOY3Duy60-zeFZA@mail.gmail.com>
Subject: Re: [PATCH net-next] qmi_wwan: unconditionally reject 2 ep interfaces
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bj=C3=B8rn,

On Sat, Feb 8, 2020 at 4:55 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
>
> We have been using the fact that the QMI and DIAG functions
> usually are the only ones with class/subclass/protocol being
> ff/ff/ff on Quectel modems. This has allowed us to match the
> QMI function without knowing the exact interface number,
> which can vary depending on firmware configuration.
>
> The ability to silently reject the DIAG function, which is
> usually handled by the option driver, is important for this
> method to work.  This is done based on the knowledge that it
> has exactly 2 bulk endpoints.  QMI function control interfaces
> will have either 3 or 1 endpoint. This rule is universal so
> the quirk condition can be removed.
>
> The fixed layouts known from the Gobi1k and Gobi2k modems
> have been gradually replaced by more dynamic layouts, and
> many vendors now use configurable layouts without changing
> device IDs.  Renaming the class/subclass/protocol matching
> macro makes it more obvious that this is now not Quectel
> specific anymore.
>
> Cc: Kristian Evensen <kristian.evensen@gmail.com>
> Cc: Aleksander Morgado <aleksander@aleksander.es>
> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
> ---
> What do you think, Kristian?  There is no real need to limit this
> rule to Quectel modems, is there?  And from what I've understood,
> it seems that most/all the upcoming X55 modems will have a
> completely configurable layout.  Which means that we should
> avoid macthing on interface number if we can.  And I believe we
> can. I've not yet seen an example where ff/ff/ff would match
> anything except QMI and DIAG.

I am sorry for my late reply, your email had for some reason ended up
in my spam filter. I agree with you reasoning and I think that making
the Quectel-code generic is a good idea. I went through the modem I
have, and could also not find any modems where the current
Quectel-code would incorrectly match. FWIW:

Acked-by: Kristian Evensen <kristian.evensen@gmail.com>

BR,
Kristian
