Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40E06C827E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjCXQiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbjCXQiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:38:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340784C15;
        Fri, 24 Mar 2023 09:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C564762BD2;
        Fri, 24 Mar 2023 16:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E44C433EF;
        Fri, 24 Mar 2023 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679675894;
        bh=Y1V4bK88VZQfI0SqX8RsPhVLv4B3WGJYz37m5Y/xaYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rIplTJQweF4ZQkpk+2pqqtuexjEEQPXqET2KTf0C6dV72Ldd45r1HB70I+0ykjBVz
         M8r3SUBm4efvT4V/UHZHHq1lXNuz6KUPFXkKgnJ82OqrOP4ywntzovHmmETZtYQTx2
         /rmgXiTm9R5GXFseskdU08IgWHT7UMLK4ESns4oYIRVsIc4dQQJrSNZAzON1r2Rzru
         8C0cp6N7HUlJxn3Xafon4QedenatJSKFSyzPdKoEREnylj5PGyg5FSRKrTglpTPinT
         rNz8iBWib/1x3BX0f4THbrKAuHVCecpp1UclQIlghhupAYuqljl2ODqtCtuOTRtyLY
         CkZC1ny8F52uA==
Date:   Fri, 24 Mar 2023 09:38:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v1 2/6] net: dsa: microchip: ksz8: fix
 ksz8_fdb_dump() to extract all 1024 entries
Message-ID: <20230324093812.331734c7@kernel.org>
In-Reply-To: <20230324053512.GG23237@pengutronix.de>
References: <20230322143130.1432106-1-o.rempel@pengutronix.de>
        <20230322143130.1432106-3-o.rempel@pengutronix.de>
        <20230323154101.1afd0081@kernel.org>
        <20230324053512.GG23237@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 06:35:12 +0100 Oleksij Rempel wrote:
> > Any reason you didn't CC Arun, just an omission or they're no longer
> > @microchip?  
> 
> He is not in MAINTAINERS for drivers/net/dsa/microchip/* even if he is
> practically maintaining it  .. :)

get_maintainer is occasionally useful in pointing out people who wrote
the code but mostly the authors of code under Fixes. I use this little
script usually:


#!/usr/bin/env python3

import argparse
import fileinput
import subprocess
import tempfile
import sys
import os
import re

emailpat = re.compile(r'([^ <"]*@[^ >"]*)')
skip = {'kuba@kernel.org',
        'davem@davemloft.net',
        'pabeni@redhat.com',
        'edumazet@google.com',
        'netdev@vger.kernel.org',
        'linux-kernel@vger.kernel.org'}


def do(lines):
    ret = ['---']

    for line in lines:
        line = line.strip()
        if not line:
            continue

        ret.append('# ' + line)

        if "moderated" in line:
            ret.append('# skip, moderated')
            continue

        match = emailpat.search(line)
        if match:
            addr = match.group(1)
            if addr in skip:
                ret.append('# skip, always-cc')

            else:
                ret.append('CC: ' + addr)
        else:
            ret.append('# Bad line')

    return ret


def run(cmd):
    p = subprocess.run(cmd, capture_output=True, check=True)
    return p.stdout.decode("utf-8").strip()


def git_commit_msg():
    return run(["git", "show", "--format=%B", "--no-patch"])


def git_commit(filename):
    return run(["git", "commit", "--amend", "-F", filename])


def git_patch_format():
    return run(["git", "format-patch", "HEAD~", "-o", "/tmp/"])


def get_maint(patch_file):
    return run(["./scripts/get_maintainer.pl",
                "--git-min-percent", "30", patch_file])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--stdin',
                        help="Read the get_maintainer output from stdin",
                        action='store_true')
    parser.add_argument('--inline', help="Amend HEAD directly",
                        action='store_true')
    args = parser.parse_args()

    if args.stdin:
        out = do(sys.stdin.readlines())
    elif args.inline:
        msg = git_commit_msg()

        patch_file = git_patch_format()
        maint = get_maint(patch_file)
        os.unlink(patch_file)

        out = do(maint.split("\n"))
        out = [l for l in out if l[0] != '#']

        tmpf = tempfile.NamedTemporaryFile(mode='w+', encoding="utf-8")
        tmpf.write(msg + '\n')
        tmpf.write('\n'.join(out))
        tmpf.flush()
        git_commit(tmpf.name)
        tmpf.close()
        out = ["Updated inline: " + msg.split("\n")[0]]
    else:
        patch_file = git_patch_format()
        maint = get_maint(patch_file)
        os.remove(patch_file)

        out = do(maint.split("\n"))

    print('\n'.join(out))

if __name__ == '__main__':
    sys.exit(main())
