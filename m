Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383565193A2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245469AbiEDBvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245268AbiEDBvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:51:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9E330F47
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:47:33 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a11so21680pff.1
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sclcWESS1vfOtw+/lNSZNu/Le9PHpJZ15I1QqAAnvbk=;
        b=aAevwHR9bd3JwLUN2/LQ5c9sjKYomRXHOOzT8MO771crgcUz3lq0Os/XqytwNxvtUl
         OUsDFPJQodMi3Gdr6qEsX6JPLYzpX2mmV6xIquzdXHmOBlRoXebJSJEipFEaZ36NWHtd
         8ThHw67NIdrIhrBqNV3S6GthwijgxDY2pMUM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sclcWESS1vfOtw+/lNSZNu/Le9PHpJZ15I1QqAAnvbk=;
        b=GuaD9gt+AJc5W1doUehxulJpH5SG86dLubGJosDSl3jnz3krkTFWOdWXWveJY1q7KT
         VqJ+jzdXlFWsIle6IuGU5NmWd1BrN+VJoVEsntl9clcH3vDGFkSbrRymrL/feilrjUIg
         foUHuFUKEsCMohBo0SKcVGDe1Oy27UobKq0/aEc36Ueeum7TkLnGfOxnjqNoNB9SYYEC
         CBQQHfVDCkNdZ7Iw+fKS+/f1l9quAuu/hbq05lBepRpucUnljP0Py/kp1tXVlp8U/w3H
         h1vKdOtm9cVAHFEeziRLm9ltwhhaZxZV5PMpES2SkQWH8jcPHUa+mu6TRzoIK9du6r87
         RvmA==
X-Gm-Message-State: AOAM533fkk+OmafTZU6KUMbou/cr/se0r+zVd9AKzu6quX2knytlp//r
        tvccJp6NtN/4Zg1SwUYN8Pneiw==
X-Google-Smtp-Source: ABdhPJzUPi96Fjb/DQUWQvNyerGs6VtmC5g6wU2czv4Ww7LsLvQHH1GWpZX27vEgkGgQ9anjBam12g==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr18620378pfu.59.1651628852898;
        Tue, 03 May 2022 18:47:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v24-20020a170902e8d800b0015ea8b4b8f3sm3957768plg.263.2022.05.03.18.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:32 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 00/32] Introduce flexible array struct memcpy() helpers
Date:   Tue,  3 May 2022 18:44:09 -0700
Message-Id: <20220504014440.3697851-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6778; h=from:subject; bh=NBPx/kHPxccGjkqS1SEj//lWw761DgDLlzW6gj8lDu4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqAMDKbiuLQ8pX7zUwKdz8OKsd8xesPXEJn90lJ iEErvqmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagAAKCRCJcvTf3G3AJjEaD/ sFb+hZKXd2lFEv0+WnlWvb0j4ta2t/UZVhsNUWQNDJHAVtv+Zlu02MxnR0jdR0CBnsA3iKMPIFMmfD pdgs6dba5/tH1Iyi6jW+wJXwtek/3ey7ygj+u19Odj4PSt0QygwmNm6MjSvTES52gqKWv74MU5t5xz L/SasXg+UAUYtWgal3FtLixo//9nvHNO1pQXa0nIFsWFnV/HFJgtQ4lutI26Hj2oKn8G30z3GHGSn4 1IRXOAidSEkPmoGdbgk1b5NrcIB4dDVp1bZOWVQ48/ez1pipyXC5BUmkDkC/X1S5WnuU0ZQ0UW1Grm 3khhO+QcGTzdaxvhpnGpJechhRJETE1ML25oQrj3M1NNy97RDl4CAzoWJillKIvj0+U+3eRoIKQc09 jVarH3JkPknzz7xPutFPSXX+ZRRa9ZIrntaHAJu8fM/gDMHvlhMmoSO/MpZW8uL4xNo34dAwBiIsfO 3kXWSB5poclt6J8JY4UGRwxeS2Ccjolknj9sm/IfEioLedUmK04grKYVaFhwm/AgWMQXfLQYxU4UVg LzieTWMmZ+uNuV5sEynHPDSzGXpTKhNmWdH0WmkjYCGd9FIF8ySFxwKVRfGpnPqbVGVOMqmYz9piV5 jE5S5aSXLfYPuj0uiXQg9UZZfkTvEGuBLHq71VsZwciiyvWRhtAG4UU4gmcQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the next phase of memcpy() buffer bounds checking[1], which
starts by adding a new set of helpers to address common code patterns
that result in memcpy() usage that can't be easily verified by the
compiler (i.e. dynamic bounds due to flexible arrays). The runtime WARN
from memcpy has been posted before, but now there's more context around
alternatives for refactoring false positives, etc.

The core of this series is patches 2 (flex_array.h), 3 (flex_array
KUnit), and 4 (runtime memcpy WARN). Patch 1 is a fix to land before 4
(and I can send separately), and everything else are examples of what the
conversions look like for one of the helpers, mem_to_flex_dup(). These
will need to land via their respective trees, but they all depend on
patch 2, which I'm hoping to land in the coming merge window.

I'm happy to also point out that the conversions (patches 5+) are actually
a net reduction in lines of code:
 49 files changed, 154 insertions(+), 244 deletions(-)

Anyway, please let me know what you think. And apologies in advance
if this is spammy; the CC list got rather large due to the "treewide"
nature of the example conversions.

Also available here:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=flexcpy/next-20220502

-Kees

[1] https://lwn.net/Articles/864521/

Kees Cook (32):
  netlink: Avoid memcpy() across flexible array boundary
  Introduce flexible array struct memcpy() helpers
  flex_array: Add Kunit tests
  fortify: Add run-time WARN for cross-field memcpy()
  brcmfmac: Use mem_to_flex_dup() with struct brcmf_fweh_queue_item
  iwlwifi: calib: Prepare to use mem_to_flex_dup()
  iwlwifi: calib: Use mem_to_flex_dup() with struct iwl_calib_result
  iwlwifi: mvm: Use mem_to_flex_dup() with struct ieee80211_key_conf
  p54: Use mem_to_flex_dup() with struct p54_cal_database
  wcn36xx: Use mem_to_flex_dup() with struct wcn36xx_hal_ind_msg
  nl80211: Use mem_to_flex_dup() with struct cfg80211_cqm_config
  cfg80211: Use mem_to_flex_dup() with struct cfg80211_bss_ies
  mac80211: Use mem_to_flex_dup() with several structs
  af_unix: Use mem_to_flex_dup() with struct unix_address
  802/garp: Use mem_to_flex_dup() with struct garp_attr
  802/mrp: Use mem_to_flex_dup() with struct mrp_attr
  net/flow_offload: Use mem_to_flex_dup() with struct flow_action_cookie
  firewire: Use __mem_to_flex_dup() with struct iso_interrupt_event
  afs: Use mem_to_flex_dup() with struct afs_acl
  ASoC: sigmadsp: Use mem_to_flex_dup() with struct sigmadsp_data
  soc: qcom: apr: Use mem_to_flex_dup() with struct apr_rx_buf
  atags_proc: Use mem_to_flex_dup() with struct buffer
  Bluetooth: Use mem_to_flex_dup() with struct
    hci_op_configure_data_path
  IB/hfi1: Use mem_to_flex_dup() for struct tid_rb_node
  Drivers: hv: utils: Use mem_to_flex_dup() with struct cn_msg
  ima: Use mem_to_flex_dup() with struct modsig
  KEYS: Use mem_to_flex_dup() with struct user_key_payload
  selinux: Use mem_to_flex_dup() with xfrm and sidtab
  xtensa: Use mem_to_flex_dup() with struct property
  usb: gadget: f_fs: Use mem_to_flex_dup() with struct ffs_buffer
  xenbus: Use mem_to_flex_dup() with struct read_buffer
  esas2r: Use __mem_to_flex() with struct atto_ioctl

 arch/arm/kernel/atags_proc.c                  |  12 +-
 arch/xtensa/platforms/xtfpga/setup.c          |   9 +-
 drivers/firewire/core-cdev.c                  |   7 +-
 drivers/hv/hv_utils_transport.c               |   7 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c     |   7 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.h     |   4 +-
 drivers/net/wireless/ath/wcn36xx/smd.c        |   8 +-
 drivers/net/wireless/ath/wcn36xx/smd.h        |   4 +-
 .../broadcom/brcm80211/brcmfmac/fweh.c        |  11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h  |   2 +-
 .../net/wireless/intel/iwlwifi/dvm/calib.c    |  23 +-
 .../net/wireless/intel/iwlwifi/dvm/ucode.c    |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |   8 +-
 drivers/net/wireless/intersil/p54/eeprom.c    |   8 +-
 drivers/net/wireless/intersil/p54/p54.h       |   4 +-
 drivers/scsi/esas2r/atioctl.h                 |   1 +
 drivers/scsi/esas2r/esas2r_ioctl.c            |  11 +-
 drivers/soc/qcom/apr.c                        |  12 +-
 drivers/usb/gadget/function/f_fs.c            |  11 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c      |  12 +-
 fs/afs/internal.h                             |   4 +-
 fs/afs/xattr.c                                |   7 +-
 include/keys/user-type.h                      |   4 +-
 include/linux/flex_array.h                    | 637 ++++++++++++++++++
 include/linux/fortify-string.h                |  70 +-
 include/linux/of.h                            |   3 +-
 include/linux/string.h                        |   1 +
 include/net/af_unix.h                         |  14 +-
 include/net/bluetooth/hci.h                   |   4 +-
 include/net/cfg80211.h                        |   4 +-
 include/net/flow_offload.h                    |   4 +-
 include/net/garp.h                            |   4 +-
 include/net/mac80211.h                        |   4 +-
 include/net/mrp.h                             |   4 +-
 include/uapi/linux/connector.h                |   4 +-
 include/uapi/linux/firewire-cdev.h            |   4 +-
 include/uapi/linux/netlink.h                  |   1 +
 include/uapi/linux/stddef.h                   |  14 +
 include/uapi/linux/xfrm.h                     |   4 +-
 lib/Kconfig.debug                             |  12 +-
 lib/Makefile                                  |   1 +
 lib/flex_array_kunit.c                        | 523 ++++++++++++++
 net/802/garp.c                                |   9 +-
 net/802/mrp.c                                 |   9 +-
 net/bluetooth/hci_request.c                   |   9 +-
 net/core/flow_offload.c                       |   7 +-
 net/mac80211/cfg.c                            |  22 +-
 net/mac80211/ieee80211_i.h                    |  12 +-
 net/netlink/af_netlink.c                      |   5 +-
 net/unix/af_unix.c                            |   7 +-
 net/wireless/core.h                           |   4 +-
 net/wireless/nl80211.c                        |  15 +-
 net/wireless/scan.c                           |  21 +-
 security/integrity/ima/ima_modsig.c           |  12 +-
 security/keys/user_defined.c                  |   7 +-
 security/selinux/ss/sidtab.c                  |   9 +-
 security/selinux/xfrm.c                       |   7 +-
 sound/soc/codecs/sigmadsp.c                   |  11 +-
 58 files changed, 1409 insertions(+), 253 deletions(-)
 create mode 100644 include/linux/flex_array.h
 create mode 100644 lib/flex_array_kunit.c

-- 
2.32.0

