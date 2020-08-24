Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F36725098A
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 21:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgHXTmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 15:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXTme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 15:42:34 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7AA1206BE;
        Mon, 24 Aug 2020 19:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598298153;
        bh=l4kk011/4tjfYHH66dtcrnHQcY+k8zmFPEvYAZmNtXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CuMUf4BexSkzp1JfPY86+RM4qxtHG462/bKjnTJLvnmcsIFJpRdBY1Yg7u/A7nsaz
         Yq2x2nz6tpVPBbpS/chznDg1PruaOrccbjHcjzFPAomxsQRmhme4AqE6LSnAEA5Ok6
         ten3NTTnZqR8m6hzbxkESChV7Fs2Jv3Wt4cfWLms=
Date:   Mon, 24 Aug 2020 12:42:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Alan Brady <Alan.Brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <Pavan.Kumar.Linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v5 01/15] virtchnl: Extend AVF ops
Message-ID: <20200824124231.61c1a04f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824173306.3178343-2-anthony.l.nguyen@intel.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Aug 2020 10:32:52 -0700 Tony Nguyen wrote:
> +struct virtchnl_rss_hash {
> +	u64 hash;
> +	u16 vport_id;
> +};
> +
> +VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_rss_hash);

I've added 32bit builds to my local setup since v4 was posted -=20
looks like there's a number of errors here. You can't assume u64=20
forces a 64bit alignment. Best to specify the padding explicitly.

FWIW these are the errors I got but there may be more:

In file included from ../drivers/net/ethernet/intel/ice/ice.h:37,
                 from ../drivers/net/ethernet/intel/ice/ice_common.h:7,
                 from ../drivers/net/ethernet/intel/ice/ice_sched.h:7,
                 from ../drivers/net/ethernet/intel/ice/ice_sched.c:4:
../include/linux/avf/virtchnl.h:175:36: warning: division by zero [-Wdiv-by=
-zero]
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                    ^
../include/linux/avf/virtchnl.h:809:1: note: in expansion of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  809 | VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_get_capabilities);
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:809:31: error: enumerator value for =E2=80=
=98virtchnl_static_assert_virtchnl_get_capabilities=E2=80=99 is not an inte=
ger constant
  809 | VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_get_capabilities);
      |                               ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:175:53: note: in definition of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                                     ^
../include/linux/avf/virtchnl.h:175:36: warning: division by zero [-Wdiv-by=
-zero]
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                    ^
../include/linux/avf/virtchnl.h:891:1: note: in expansion of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  891 | VIRTCHNL_CHECK_STRUCT_LEN(40, virtchnl_txq_info_v2);
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:891:31: error: enumerator value for =E2=80=
=98virtchnl_static_assert_virtchnl_txq_info_v2=E2=80=99 is not an integer c=
onstant
  891 | VIRTCHNL_CHECK_STRUCT_LEN(40, virtchnl_txq_info_v2);
      |                               ^~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:175:53: note: in definition of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                                     ^
../include/linux/avf/virtchnl.h:175:36: warning: division by zero [-Wdiv-by=
-zero]
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                    ^
../include/linux/avf/virtchnl.h:907:1: note: in expansion of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  907 | VIRTCHNL_CHECK_STRUCT_LEN(48, virtchnl_config_tx_queues);
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:907:31: error: enumerator value for =E2=80=
=98virtchnl_static_assert_virtchnl_config_tx_queues=E2=80=99 is not an inte=
ger constant
  907 | VIRTCHNL_CHECK_STRUCT_LEN(48, virtchnl_config_tx_queues);
      |                               ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:175:53: note: in definition of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                                     ^
../include/linux/avf/virtchnl.h:175:36: warning: division by zero [-Wdiv-by=
-zero]
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                    ^
../include/linux/avf/virtchnl.h:937:1: note: in expansion of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  937 | VIRTCHNL_CHECK_STRUCT_LEN(72, virtchnl_rxq_info_v2);
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:937:31: error: enumerator value for =E2=80=
=98virtchnl_static_assert_virtchnl_rxq_info_v2=E2=80=99 is not an integer c=
onstant
  937 | VIRTCHNL_CHECK_STRUCT_LEN(72, virtchnl_rxq_info_v2);
      |                               ^~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:175:53: note: in definition of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                                     ^
../include/linux/avf/virtchnl.h:175:36: warning: division by zero [-Wdiv-by=
-zero]
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                    ^
../include/linux/avf/virtchnl.h:952:1: note: in expansion of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  952 | VIRTCHNL_CHECK_STRUCT_LEN(80, virtchnl_config_rx_queues);
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:952:31: error: enumerator value for =E2=80=
=98virtchnl_static_assert_virtchnl_config_rx_queues=E2=80=99 is not an inte=
ger constant
  952 | VIRTCHNL_CHECK_STRUCT_LEN(80, virtchnl_config_rx_queues);
      |                               ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:175:53: note: in definition of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                                     ^
../include/linux/avf/virtchnl.h:175:36: warning: division by zero [-Wdiv-by=
-zero]
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
      |                                    ^
../include/linux/avf/virtchnl.h:1090:1: note: in expansion of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
 1090 | VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_rss_hash);
      | ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:1090:31: error: enumerator value for =E2=80=
=98virtchnl_static_assert_virtchnl_rss_hash=E2=80=99 is not an integer cons=
tant
 1090 | VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_rss_hash);
      |                               ^~~~~~~~~~~~~~~~~
../include/linux/avf/virtchnl.h:175:53: note: in definition of macro =E2=80=
=98VIRTCHNL_CHECK_STRUCT_LEN=E2=80=99
  175 |  { virtchnl_static_assert_##X =3D (n)/((sizeof(struct X) =3D=3D (n)=
) ? 1 : 0) }
